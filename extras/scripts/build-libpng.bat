@echo off

setlocal
SET XSRC_DIR=%~dp0..\..\src\
SET XLIB_DIR=%~dp0

SET XLIBPNG_32=%XLIB_DIR%libpng-x86\Release\
SET XLIBPNG_64=%XLIB_DIR%libpng-x64\Release\
SET XZLIB_32=%XLIB_DIR%zlib-x86\Release\
SET XZLIB_64=%XLIB_DIR%zlib-x64\Release\

rem 克隆 zlib 和 libpng 仓库
git clone https://github.com/madler/zlib
git clone https://github.com/pnggroup/libpng

rem 构建 zlib x86
cmake -S zlib -B zlib-x86 -A Win32 -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DZLIB_BUILD_TESTING=OFF -DZLIB_BUILD_SHARED=OFF -DZLIB_BUILD_STATIC=ON -DZLIB_INSTALL=ON
cmake --build zlib-x86 --config Release

rem 构建 libpng x86
cmake -S libpng -B libpng-x86 -A Win32 -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DPNG_STATIC=ON -DPNG_SHARED=OFF -DZLIB_INCLUDE_DIR=%XLIB_DIR%\zlib -DZLIB_LIBRARY=%XLIB_DIR%\zlib-x86\Release\zs.lib
cmake --build libpng-x86 --config Release

rem 构建 zlib x64
cmake -S zlib -B zlib-x64 -A x64 -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DZLIB_BUILD_TESTING=OFF -DZLIB_BUILD_SHARED=OFF -DZLIB_BUILD_STATIC=ON -DZLIB_INSTALL=ON
cmake --build zlib-x64 --config Release

rem 构建 libpng x64
cmake -S libpng -B libpng-x64 -A x64 -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DPNG_STATIC=ON -DPNG_SHARED=OFF -DZLIB_INCLUDE_DIR=%XLIB_DIR%\zlib -DZLIB_LIBRARY=%XLIB_DIR%\zlib-x64\Release\zs.lib
cmake --build libpng-x64 --config Release


copy /y "%XLIB_DIR%libpng\png.h" "%XSRC_DIR%JPEGView\libpng\include\"
copy /y "%XLIB_DIR%libpng\pngconf.h" "%XSRC_DIR%JPEGView\libpng\include\"
copy /y "%XLIB_DIR%libpng-x64\pnglibconf.h" "%XSRC_DIR%JPEGView\libpng\include\"

copy /y "%XLIBPNG_32%libpng18_static.lib" "%XSRC_DIR%JPEGView\libpng\lib\"
copy /y "%XLIBPNG_64%libpng18_static.lib" "%XSRC_DIR%JPEGView\libpng\lib64\"

copy /y "%XZLIB_32%zs.lib" "%XSRC_DIR%JPEGView\libpng\lib\"
copy /y "%XZLIB_64%zs.lib" "%XSRC_DIR%JPEGView\libpng\lib64\"
