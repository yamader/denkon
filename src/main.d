import std;
import bitmap;

enum asset(string name) = cast(immutable ubyte[])import(name);

enum files = ({
  enum cnt = 3;
  enum fmt = "frame%d.bmp";
  enum names = cnt.iota.map!(i => format(fmt, i)).array;
  auto a = staticMap!(asset, AliasSeq!names);
  return names;
})();

void main(string[] args) {
  files.writeln;
}
