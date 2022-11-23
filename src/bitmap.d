import std;

struct Color {
  ubyte[] bgra;

  auto ref b() => bgra[0];
  auto ref g() => bgra[1];
  auto ref r() => bgra[2];
  auto ref a() => bgra[3];

  auto x256() {
  }
}

struct Bitmap {
  size_t width, height;
  Color[][] data;
}

auto unpack(T, U: ubyte)(U[] buf) {
  auto fixed = cast(U[T.sizeof])buf[0..T.sizeof];
  return fixed.littleEndianToNative!T;
}

auto parse(T: ubyte)(T[] buf) {
  auto offs   = buf[0x0a..0x0e].unpack!uint;
  auto width  = buf[0x12..0x16].unpack!int;
  auto height = buf[0x16..0x1a].unpack!int;

  // BITMAPV5HEADER only
  if(buf[0x1c..0x1e].unpack!ushort != 32)
    fatal("format is not supported");

  return const Bitmap(width, height,
    buf[offs..$]
      .chunks(4).map!(a => const Color(a)).array
      .chunks(width).array.reverse);
}
