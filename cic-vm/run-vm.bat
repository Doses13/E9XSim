@echo off
setlocal

set "QEMU=C:\Program Files\qemu\qemu-system-aarch64.exe"
set "VM_DIR=%~dp0"

echo Starting E9XSim CIC VM...

"%QEMU%" ^
    -name "E9XSim CIC" ^
    -machine virt ^
    -cpu max ^
    -accel tcg,thread=multi ^
    -smp 4 ^
    -m 4096 ^
    -bios "C:\Program Files\qemu\share\edk2-aarch64-code.fd" ^
    -drive "file=%VM_DIR%cic.qcow2,if=virtio,format=qcow2" ^
    -device virtio-gpu-gl-pci ^
    -device qemu-xhci ^
    -device usb-kbd ^
    -device usb-tablet ^
    -device virtio-net-pci,netdev=net0 ^
    -display sdl,gl=on ^
    -netdev user,id=net0,hostfwd=tcp::2222-:22

endlocal