# For additional build parameters
CONFIG(debug, debug|release) {
    DESTDIR = ../build/debug
} else {
    DESTDIR = ../build/release
}