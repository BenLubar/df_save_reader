require_relative 'io.rb'

class IO
  def read_book
    Book.new self
  end
end

class Book
  def initialize io  
    magic = io.read 8 # the byte sequence d0 8a d0 8a d0 8a 00 00
    if magic != "\xd0\x8a\xd0\x8a\xd0\x8a\x00\x00".force_encoding(Encoding::BINARY)
      io.seek -8, IO::SEEK_CUR
      raise StopIteration
    end

    a = io.read_uint32 # a 32-bit bitfield - 0x00000804 has 6 bytes at the end that 0x00000004 doesn't. (A)
    raise "Unexpected value for book[A]: #{a}" unless a == 0x804 or a == 0x4

    3.times do |i| # there are 48 bits, all of them zeroes.
      tmp = io.read_uint16
      raise "Unexpected value for book[#{i}]: #{tmp}" unless tmp == 0
    end

    b = io.read_uint32 # there's a 32 bit integer that monotonically increases. (B)

    # the following 32 bit integers: 0, 1, 1.
    tmp = io.read_int32
    raise "Unexpected value for book[3]: #{tmp}" unless tmp == 0
    tmp = io.read_int32
    raise "Unexpected value for book[4]: #{tmp}" unless tmp == 1
    tmp = io.read_int32
    raise "Unexpected value for book[5]: #{tmp}" unless tmp == 1

    tmp = io.read_uint32 # B is repeated.
    raise "Unexpected value (expected #{b}) for book[6]: #{tmp}" unless tmp == b

    # the following 32 bit integers: -1, -1, 1.
    tmp = io.read_int32
    raise "Unexpected value for book[7]: #{tmp}" unless tmp == -1
    tmp = io.read_int32
    raise "Unexpected value for book[8]: #{tmp}" unless tmp == -1
    tmp = io.read_int32
    raise "Unexpected value for book[9]: #{tmp}" unless tmp == 1

    3.times do |i| # 24 bits, all of them zeroes.
      tmp = io.read_uint8
      raise "Unexpected value for book[#{i + 10}]: #{tmp}" unless tmp == 0
    end

    tmp = io.read_uint16 # the 16 bit integer 0x2742 (ASCII B', which looks like "Book"(?))
    raise "Unexpected value (expected #{0x2742}) for book[13]: #{tmp}" unless tmp == 0x2742

    # the following 32 bit integers: 0, 0, -1.
    tmp = io.read_int32
    raise "Unexpected value for book[14]: #{tmp}" unless tmp == 0
    tmp = io.read_int32
    raise "Unexpected value for book[15]: #{tmp}" unless tmp == 0
    tmp = io.read_int32
    raise "Unexpected value for book[16]: #{tmp}" unless tmp == -1

    # 16 bit integer. (C)
    c = io.read_uint16

    # 32 bit signed integer. (D)
    d = io.read_int32

    # the following 16 bit integers: -1, 0, 0, 0.
    tmp = io.read_int16
    raise "Unexpected value for book[17]: #{tmp}" unless tmp == -1
    g = io.read_int16
    raise "Unexpected value for book[G]: #{g}" unless (a & 0x800 != 0x800 and g == 0) or (a & 0x800 == 0x800 and g == 5)
    tmp = io.read_int16
    raise "Unexpected value for book[19]: #{tmp}" unless tmp == 0
    tmp = io.read_int16
    raise "Unexpected value for book[20]: #{tmp}" unless tmp == 0

    # 32 bit integer. (E)
    e = io.read_uint32

    # the following 32 bit integer: -1.
    tmp = io.read_int32
    raise "Unexpected value for book[21]: #{tmp}" unless tmp == -1

    # 32 bit integer. (F)
    f = io.read_uint32

    raise "Unexpected value for book[F]: #{f}" if f > 3

    i = ''
    if f & 2 == 2
      i = io.read 74
    end
    if f & 1 == 1
      i = io.read 40
    end

    h = io.read_string

    j = ''
    if a & 0x800 == 0x800
      j = io.read 6
    end

    case g
    when 0
      printf "[BOOK:%d] ", b
    when 5
      printf "[SLAB:%d] ", b
    end

    if h.empty?
      puts "Untitled"
    else
      p h
    end

    case c
    when 0
            puts $string_tables[:inorganic][d].downcase
    when 3
            raise "Unexpected value for book[D]: #{d} (expected -1)" unless d == -1
            puts "green glass"
    when 4
            raise "Unexpected value for book[D]: #{d} (expected -1)" unless d == -1
            puts "clear glass"
    when 21, 22
            puts $string_tables[:creature][d].downcase + " bone"
    when 25
            puts $string_tables[:creature][d].downcase + " tooth"
    when 36, 37, 38
            puts $string_tables[:creature][d].downcase + " leather"
    when 39
            puts $string_tables[:creature][d].downcase + " shell"
    when 41
            puts $string_tables[:creature][d].downcase + " hoof"
    when 42
            puts $string_tables[:creature][d].downcase + " ivory"
    when 420
            puts $string_tables[:plant][d].downcase + " bark"
    when 421
            puts $string_tables[:plant][d].downcase + " fiber"
    else
            raise "Unexpected value for book[C]: #{c}"
    end

    puts e
    i.each_byte do |b|
      printf "%02x ", b
    end
    puts
    j.each_byte do |b|
      printf "%02x ", b
    end
    puts
    puts
  end
end

# vim: set tabstop=2 expandtab:
