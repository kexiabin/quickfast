./b2 variant=release link=shared threading=multi runtime-link=shared \
    --without-graph \
    --without-graph_parallel \
    --without-mpi \
    --withou-python \
    --without-wave \
    install --prefix=/home/HarryWu/github/quickfast/linux/deps
    
./configure --prefix=/home/HarryWu/github/quickfast/linux/deps && make && make install

tar zxvf /home/HarryWu/tmp/MPC_4_1_0.tar.gz \
    -C /home/HarryWu/github/quickfast/linux/deps

# make sure to use command `.' (or the `source')
. ./setup.sh && . ./m.sh  && make

# Finally, you will find output in ./lib & ./bin 

ldd lib/libQuickFAST.so

	linux-vdso.so.1 =>  (0x00007fff151ff000)
	libxerces-c-3.1.so => /home/HarryWu/github/quickfast/linux/deps/xerces/lib/libxerces-c-3.1.so (0x00007fca5ce51000)
	libboost_thread.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_thread.so.1.57.0 (0x00007fca5cc2d000)
	libboost_system.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_system.so.1.57.0 (0x00007fca5ca2a000)
	libboost_filesystem.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_filesystem.so.1.57.0 (0x00007fca5c813000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fca5c5f1000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fca5c3d5000)
	libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0x00007fca5c0ca000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fca5be47000)
	libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x00007fca5bc31000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fca5b8a7000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fca5d755000)
	libnsl.so.1 => /lib/x86_64-linux-gnu/libnsl.so.1 (0x00007fca5b68e000)
	libcurl.so.4 => /usr/lib/x86_64-linux-gnu/libcurl.so.4 (0x00007fca5b425000)
	libicui18n.so.48 => /usr/lib/x86_64-linux-gnu/libicui18n.so.48 (0x00007fca5b059000)
	libicuuc.so.48 => /usr/lib/x86_64-linux-gnu/libicuuc.so.48 (0x00007fca5ace9000)
	libicudata.so.48 => /usr/lib/x86_64-linux-gnu/libicudata.so.48 (0x00007fca59979000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007fca59771000)
	libidn.so.11 => /usr/lib/x86_64-linux-gnu/libidn.so.11 (0x00007fca5953c000)
	libssh2.so.1 => /usr/lib/x86_64-linux-gnu/libssh2.so.1 (0x00007fca59313000)
	liblber-2.4.so.2 => /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 (0x00007fca59103000)
	libldap_r-2.4.so.2 => /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2 (0x00007fca58eb2000)
	libgssapi_krb5.so.2 => /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 (0x00007fca58c73000)
	libssl.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 (0x00007fca58a13000)
	libcrypto.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007fca5862f000)
	librtmp.so.0 => /usr/lib/x86_64-linux-gnu/librtmp.so.0 (0x00007fca58415000)
	libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fca581fd000)
	libgcrypt.so.11 => /lib/x86_64-linux-gnu/libgcrypt.so.11 (0x00007fca57f7f000)
	libresolv.so.2 => /lib/x86_64-linux-gnu/libresolv.so.2 (0x00007fca57d68000)
	libsasl2.so.2 => /usr/lib/x86_64-linux-gnu/libsasl2.so.2 (0x00007fca57b4d000)
	libgnutls.so.26 => /usr/lib/x86_64-linux-gnu/libgnutls.so.26 (0x00007fca5788d000)
	libkrb5.so.3 => /usr/lib/x86_64-linux-gnu/libkrb5.so.3 (0x00007fca575b8000)
	libk5crypto.so.3 => /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 (0x00007fca5738f000)
	libcom_err.so.2 => /lib/x86_64-linux-gnu/libcom_err.so.2 (0x00007fca5718b000)
	libkrb5support.so.0 => /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 (0x00007fca56f81000)
	libkeyutils.so.1 => /lib/x86_64-linux-gnu/libkeyutils.so.1 (0x00007fca56d7d000)
	libgpg-error.so.0 => /lib/x86_64-linux-gnu/libgpg-error.so.0 (0x00007fca56b79000)
	libtasn1.so.3 => /usr/lib/x86_64-linux-gnu/libtasn1.so.3 (0x00007fca56968000)
	libp11-kit.so.0 => /usr/lib/x86_64-linux-gnu/libp11-kit.so.0 (0x00007fca56756000)

ldd bin/InterpretApplication

	linux-vdso.so.1 =>  (0x00007ffffe318000)
	libQuickFAST.so => /home/HarryWu/github/quickfast/linux/quickfast_1_5_0/lib/libQuickFAST.so (0x00007f62674ad000)
	libboost_thread.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_thread.so.1.57.0 (0x00007f6267289000)
	libboost_system.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_system.so.1.57.0 (0x00007f6267086000)
	libboost_filesystem.so.1.57.0 => /home/HarryWu/github/quickfast/linux/deps/boost/lib/libboost_filesystem.so.1.57.0 (0x00007f6266e6f000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f6266c4d000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f6266a31000)
	libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0x00007f6266726000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f62664a3000)
	libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x00007f626628d000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f6265f03000)
	libxerces-c-3.1.so => /home/HarryWu/github/quickfast/linux/deps/xerces/lib/libxerces-c-3.1.so (0x00007f626595b000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f626780a000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f6265753000)
	libnsl.so.1 => /lib/x86_64-linux-gnu/libnsl.so.1 (0x00007f626553a000)
	libcurl.so.4 => /usr/lib/x86_64-linux-gnu/libcurl.so.4 (0x00007f62652d1000)
	libicui18n.so.48 => /usr/lib/x86_64-linux-gnu/libicui18n.so.48 (0x00007f6264f05000)
	libicuuc.so.48 => /usr/lib/x86_64-linux-gnu/libicuuc.so.48 (0x00007f6264b95000)
	libicudata.so.48 => /usr/lib/x86_64-linux-gnu/libicudata.so.48 (0x00007f6263825000)
	libidn.so.11 => /usr/lib/x86_64-linux-gnu/libidn.so.11 (0x00007f62635f1000)
	libssh2.so.1 => /usr/lib/x86_64-linux-gnu/libssh2.so.1 (0x00007f62633c7000)
	liblber-2.4.so.2 => /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 (0x00007f62631b8000)
	libldap_r-2.4.so.2 => /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2 (0x00007f6262f67000)
	libgssapi_krb5.so.2 => /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 (0x00007f6262d27000)
	libssl.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 (0x00007f6262ac8000)
	libcrypto.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007f62626e4000)
	librtmp.so.0 => /usr/lib/x86_64-linux-gnu/librtmp.so.0 (0x00007f62624c9000)
	libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f62622b2000)
	libgcrypt.so.11 => /lib/x86_64-linux-gnu/libgcrypt.so.11 (0x00007f6262033000)
	libresolv.so.2 => /lib/x86_64-linux-gnu/libresolv.so.2 (0x00007f6261e1d000)
	libsasl2.so.2 => /usr/lib/x86_64-linux-gnu/libsasl2.so.2 (0x00007f6261c02000)
	libgnutls.so.26 => /usr/lib/x86_64-linux-gnu/libgnutls.so.26 (0x00007f6261941000)
	libkrb5.so.3 => /usr/lib/x86_64-linux-gnu/libkrb5.so.3 (0x00007f626166d000)
	libk5crypto.so.3 => /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 (0x00007f6261444000)
	libcom_err.so.2 => /lib/x86_64-linux-gnu/libcom_err.so.2 (0x00007f626123f000)
	libkrb5support.so.0 => /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 (0x00007f6261036000)
	libkeyutils.so.1 => /lib/x86_64-linux-gnu/libkeyutils.so.1 (0x00007f6260e32000)
	libgpg-error.so.0 => /lib/x86_64-linux-gnu/libgpg-error.so.0 (0x00007f6260c2e000)
	libtasn1.so.3 => /usr/lib/x86_64-linux-gnu/libtasn1.so.3 (0x00007f6260a1d000)
	libp11-kit.so.0 => /usr/lib/x86_64-linux-gnu/libp11-kit.so.0 (0x00007f626080b000)

