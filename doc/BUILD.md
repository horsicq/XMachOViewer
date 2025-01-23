# Build Instructions for XMachOViewer

## Prerequisites

Before you start building XMachOViewer, ensure you have the following tools installed:

- **CMake**: Version 3.10 or higher
- **Qt**: Qt5 or higher
- **Compiler**: GCC, Clang, or MSVC

## Building on Linux

1. **Install dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install cmake qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools build-essential
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/horsicq/XMachOViewer.git
   cd XMachOViewer
   ```

3. **Create a build directory**:
   ```bash
   mkdir build
   cd build
   ```

4. **Generate Makefiles using CMake**:
   ```bash
   cmake ..
   ```

5. **Build the project**:
   ```bash
   make
   ```

## Building on Windows

1. **Install dependencies**:
   - Download and install [CMake](https://cmake.org/download/).
   - Download and install [Qt](https://www.qt.io/download).
   - Install a C++ compiler (Visual Studio is recommended).

2. **Clone the repository**:
   ```sh
   git clone https://github.com/horsicq/XMachOViewer.git
   cd XMachOViewer
   ```

3. **Create a build directory**:
   ```sh
   mkdir build
   cd build
   ```

4. **Generate Visual Studio project files using CMake**:
   ```sh
   cmake .. -G "Visual Studio 16 2019"
   ```

5. **Build the project**:
   Open the generated `.sln` file in Visual Studio and build the solution.

## Building on macOS

1. **Install dependencies**:
   ```sh
   brew install cmake qt
   ```

2. **Clone the repository**:
   ```sh
   git clone https://github.com/horsicq/XMachOViewer.git
   cd XMachOViewer
   ```

3. **Create a build directory**:
   ```sh
   mkdir build
   cd build
   ```

4. **Generate Makefiles using CMake**:
   ```sh
   cmake ..
   ```

5. **Build the project**:
   ```sh
   make
   ```

## Additional Notes

- Ensure that the Qt installation path is correctly set in your environment variables.
- For any issues encountered during the build process, refer to the [GitHub Issues](https://github.com/horsicq/XMachOViewer/issues) page for troubleshooting and support.