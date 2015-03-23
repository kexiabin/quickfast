package VC8WorkspaceCreator;

# ************************************************************
# Description   : A VC8 Workspace Creator
# Author        : Johnny Willemsen
# Create Date   : 4/21/2004
# $Id: VC8WorkspaceCreator.pm 2214 2014-06-30 12:34:00Z elliott_c $
# ************************************************************

# ************************************************************
# Pragmas
# ************************************************************

use strict;

use VC8ProjectCreator;
use VC71WorkspaceCreator;

use vars qw(@ISA);
@ISA = qw(VC71WorkspaceCreator);

# ************************************************************
# Data Section
# ************************************************************

## NOTE: We call the constant as a function to support Perl 5.6.
my %lang_map = (Creator::cplusplus() => 'Visual C#',
                Creator::csharp()    => 'Visual C#',
                Creator::vb()        => 'Visual Basic',
                Creator::java()      => 'Visual J#');

# ************************************************************
# Subroutine Section
# ************************************************************

sub pre_workspace {
  my($self, $fh) = @_;
  my $crlf = $self->crlf();

  ## This identifies it as a Visual Studio 2005 file
  print $fh '﻿', $crlf,
            'Microsoft Visual Studio Solution File, Format Version 9.00', $crlf;

  ## Optionally print the workspace comment
  $self->print_workspace_comment($fh,
            '# Visual Studio 2005', $crlf,
            '# $Id: VC8WorkspaceCreator.pm 2214 2014-06-30 12:34:00Z elliott_c $', $crlf,
            '#', $crlf,
            '# This file was generated by MPC.  Any changes made directly to', $crlf,
            '# this file will be lost the next time it is generated.', $crlf,
            '#', $crlf,
            '# MPC Command:', $crlf,
            '# ', $self->create_command_line_string($0, @ARGV), $crlf);
}

sub post_workspace {
  my($self, $fh, $creator) = @_;
  my $pjs = $self->get_project_info();
  my @projects = $self->sort_dependencies($self->get_projects(), 0);
  my %gmap;

  ## Store a map of the project name to project guid and whether or not
  ## it is suitable to be referenced.  Adding a reference to a
  ## non-managed c++ library or a "utility" project causes a warning in
  ## Visual Studio 2008 and higher.
  foreach my $project (@projects) {
    my($name, $guid, $lang, $custom_only, $managed) =
      $creator->access_pi_values($pjs, $project,
                                 ProjectCreator::PROJECT_NAME,
                                 ProjectCreator::PROJECT_GUID,
                                 ProjectCreator::LANGUAGE,
                                 ProjectCreator::CUSTOM_ONLY,
                                 ProjectCreator::MANAGED_PROJECT);
    $gmap{$name} = [$guid, !$custom_only && ($managed ||
                                             $lang ne Creator::cplusplus)];
  }

  ## Now go through the projects and check for the need to add external
  ## references.
  foreach my $project (@projects) {
    my $ph     = new FileHandle();
    my $outdir = $self->get_outdir();
    $outdir    = $self->getcwd() if ($outdir eq '.');
    if (open($ph, "$outdir/$project")) {
      my $write;
      my @read;
      my $crlf = $self->crlf();
      my $cwd  = $self->getcwd();
      my $lang = $$pjs{$project}->[ProjectCreator::LANGUAGE];
      my $managed = $$pjs{$project}->[ProjectCreator::MANAGED_PROJECT];

      while(<$ph>) {
        ## This is a comment found in vc8.mpd if the project contains the
        ## 'after' keyword setting and the 'add_references' template
        ## variable setting.
        if (/^(\s*)<!\-\-\s+MPC\s+ADD\s+DEPENDENCIES/) {
          my $spc  = $1;
          my $deps = $self->get_validated_ordering($project);
          foreach my $dep (@$deps) {
            my $relative = $self->get_relative_dep_file($creator,
                                                        "$cwd/$project",
                                                        $dep);
            if (defined $relative) {
              $relative =~ s!/!\\!g;

              if ($lang eq Creator::cplusplus) {
                ## If the current project is not managed, then we will
                ## add references (although I doubt that will be useful).
                ## If the current project is managed, then the reference
                ## project must be managed or a non-c++ project.
                if (!$managed || ($managed && $gmap{$dep}->[1])) {
                  ## See if the dependency has an associated attribute.
                  ## If it does, split it into name value pairs for use in
                  ## the resulting generated XML.
                  my %attr;
                  my $attr = $creator->get_dependency_attribute($dep);
                  if (defined $attr) {
                    foreach my $a (split(',', $attr)) {
                      my @nvp = split('=', $a);
                      $attr{lc($nvp[0])} = $nvp[1] if (defined $nvp[0] &&
                                                       defined $nvp[1]);
                    }
                  }

                  push(@read, $self->cpp_proj_ref($spc, $gmap{$dep}->[0],
                                                  \%attr, $relative));
                }
              }
              ## This is a non-c++ language.  So, it should not reference
              ## unmanaged c++ libraries.  If it's a managed project or
              ## it's not a c++ project, it's ok to add a reference.
              elsif ($gmap{$dep}->[1]) {
                ## There are situations where, in C#, we want a dependency
                ## between projects but not want them linked together (via a
                ## ProjectReference).  There is a build dependency, i.e.,
                ## this project needs to be built if some other project is
                ## built.  But, that's where the dependency ends.  Setting
                ## the ProjectReference attribute to false allows us to do
                ## that.
                my $attr = $creator->get_dependency_attribute($dep);
                if (!defined $attr || $attr !~ /ProjectReference=false/i) {
                  push(@read, $spc . '<ProjectReference Include="' .
                              $relative . '">' . $crlf,
                              $spc . '  <Project>{' . $gmap{$dep}->[0] .
                              '}</Project>' . $crlf,
                              $spc . '  <Name>' . $dep . '</Name>' . $crlf,
                              $spc . '</ProjectReference>' . $crlf);
                }
              }

              ## Indicate that we need to re-write the file
              $write = 1;
            }
          }
          last if (!$write);
        }
        else {
          push(@read, $_);
        }
      }
      close($ph);

      ## If we need to re-write the file, then do so
      if ($write && open($ph, ">$outdir/$project")) {
        foreach my $line (@read) {
          print $ph $line;
        }
        close($ph);
      }
    }
  }
}

sub cpp_proj_ref {
  my ($self, $spc, $refguid, $attr, $relative) = @_;
  my $crlf = $self->crlf();
  return $spc . '<ProjectReference' . $crlf .
      $spc . "\tReferencedProjectIdentifier=\"\{$refguid\}\"$crlf" .
      (defined $$attr{'copylocal'}
       ? $spc . "\tCopyLocal=\"" . $$attr{'copylocal'} . "\"$crlf"
       : ''
      ) .
      $spc . "\tRelativePathToProject=\"$relative\"$crlf" .
      $spc . '/>' . $crlf;
}

sub adjust_names {
  my($self, $name, $proj, $lang) = @_;

  ## For websites, the project needs to be the directory of the actual
  ## project file with a trailing slash.  The name needs a trailing slash
  ## too.
  if ($lang eq Creator::website) {
    $proj = $self->mpc_dirname($proj);
    $proj .= '\\';
    $name .= '\\' if $self->website_trailing_slash();
  }

  ## This always needs to be a path with the Windows style directory
  ## separator.
  $proj =~ s/\//\\/g;
  return $name, $proj;
}

sub website_trailing_slash {
  return 1;
}

sub website_extra_props {
}

sub get_short_config_name {
  #my($self, $cfg) = @_;
  return $_[1];
}

sub get_solution_config_section_name {
  #my $self = shift;
  return 'SolutionConfigurationPlatforms';
}

sub get_project_config_section_name {
  #my $self = shift;
  return 'ProjectConfigurationPlatforms';
}

sub print_additional_sections {
  my($self, $fh) = @_;
  my $crlf = $self->crlf();

  print $fh "\tGlobalSection(SolutionProperties) = preSolution$crlf",
            "\t\tHideSolutionNode = FALSE$crlf",
            "\tEndGlobalSection$crlf";
}

sub allow_empty_dependencies {
  #my $self = shift;
  return 0;
}

sub print_inner_project {
  my($self, $fh, $gen, $currguid, $deps, $name, $name_to_guid_map, $proj_language, $cfgs) = @_;

  ## We need to perform a lot of work, but only for websites.
  if ($proj_language eq Creator::website) {
    my $crlf      = $self->crlf();
    my $directory = ($name eq '.\\' ?
                       $self->get_workspace_name() . '\\' : $name);

    ## We need the directory name with no trailing back-slash for use
    ## below.
    my $notrail   = $directory;
    $notrail =~ s/\\$//;

    # Print the website project.
    print $fh "\tProjectSection(WebsiteProperties) = preProject", $crlf;

    $self->website_extra_props($fh);

    ## Print out the references
    my $references;
    foreach my $dep (@$deps) {
      if (defined $$name_to_guid_map{$dep}) {
        $references = "\t\t" .
                      'ProjectReferences = "' if (!defined $references);
        $references .= "{$$name_to_guid_map{$dep}}|$dep;";
      }
    }
    print $fh $references, '"', $crlf if (defined $references);

    ## And now the configurations
    my %cfg_seen;
    foreach my $config (@$cfgs) {
      $config =~ s/\|.*//;
      if (!$cfg_seen{$config}) {
        print $fh "\t\t$config.AspNetCompiler.VirtualPath = \"/$notrail\"", $crlf,
                  "\t\t$config.AspNetCompiler.PhysicalPath = \"$directory\"", $crlf,
                  "\t\t$config.AspNetCompiler.TargetPath = \"PrecompiledWeb\\$directory\"", $crlf,
                  "\t\t$config.AspNetCompiler.Updateable = \"true\"", $crlf,
                  "\t\t$config.AspNetCompiler.ForceOverwrite = \"true\"", $crlf,
                  "\t\t$config.AspNetCompiler.FixedNames = \"true\"", $crlf,
                  "\t\t$config.AspNetCompiler.Debug = \"",
                  ($config =~ /debug/i ? 'True' : 'False'), "\"", $crlf;
        $cfg_seen{$config} = 1;
      }
    }
    print $fh "\t\tVWDPort = \"1573\"", $crlf,
              "\t\tDefaultWebSiteLanguage = \"",
              $lang_map{$self->get_language()}, "\"", $crlf,
              "\tEndProjectSection", $crlf;
  }
  else {
    # We can ignore this project and pass it to the
    # SUPER since it's not a website.
    $self->SUPER::print_inner_project($fh, $gen, $currguid, $deps,
                                      $name, $name_to_guid_map);
  }
}

1;
