import std;
import core.thread;
import bitmap;
import x256;

enum Denkon { Big8, Big24, Small8, Small24 }

enum assets(string fmt, size_t n) = mixin("["~
  iota(n).map!(i => format(q{
    cast(immutable ubyte[])import("%s")
  }, format(fmt, i))).join(',')
~"]");

enum big = assets!("big%d.bmp", 3).map!parse.array,
     small = assets!("small%d.bmp", 3).map!parse.array;
enum big8 = big.map!(pic => render(pic.data, false)).array,
     big24 = big.map!(pic => render(pic.data, true)).array,
     small8 = small.map!(pic => render(pic.data, false)).array,
     small24 = small.map!(pic => render(pic.data, true)).array;

auto sleep(size_t ms) => Thread.sleep(ms.dur!("msecs"));

auto size() {
  version(Posix) {
    import core.sys.posix.unistd, core.sys.posix.sys.ioctl;
    winsize ws;
    if(ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) < 0)
      throw new Error("ioctl TIOCGWINSZ failed");
    return tuple!("row", "col")(ws.ws_row, ws.ws_col);
  }
}

void main(string[] args) {
  sleep(1000);
  big24.each!(each!((row) {
    row.each!write;
    writeln;
  }));

  //small24.each!((row) {
  //  row.each!write;
  //  writeln;
  //});

  //big8.each!((row) {
  //  row.each!write;
  //  writeln;
  //});

  //big24.each!((row) {
  //  row.each!write;
  //  writeln;
  //});
}
