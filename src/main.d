import std;
import bitmap;

enum assets(string fmt, size_t n) = mixin("["~
  iota(n).map!(i => format(q{
    cast(immutable ubyte[])import("%s")
  }, format(fmt, i))).join(',')
~"]");

enum big = assets!("big%d.bmp", 3).map!parse.array;
enum small = assets!("small%d.bmp", 3).map!parse.array;

auto size() {
  version(Posix) {
    import core.sys.posix.unistd, core.sys.posix.sys.ioctl;
    winsize ws;
    if(ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) < 0)
      throw new Error("ioctl TIOCGWINSZ failed");
    return tuple!("row", "col")(ws.ws_row, ws.ws_col);
  }
}

// full color: experimental

void main(string[] args) {
  //small.each!((frame) {
  //});
  size.writeln;
}
