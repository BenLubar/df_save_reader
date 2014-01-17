class IO
  def read_unpack len, format
    self.read(len).unpack(format)[0]
  end

  def read_int8
    self.read_unpack 1, 'c'
  end
  def read_uint8
    self.read_unpack 1, 'C'
  end
  def read_int16
    self.read_unpack 2, 's<'
  end
  def read_uint16
    self.read_unpack 2, 'S<'
  end
  def read_int32
    self.read_unpack 4, 'l<'
  end
  def read_uint32
    self.read_unpack 4, 'L<'
  end
  def read_int64
    self.read_unpack 8, 'q<'
  end
  def read_uint64
    self.read_unpack 8, 'Q<'
  end
  def read_string
    self.read(self.read_uint16).force_encoding(Encoding::CP437).encode!(Encoding::UTF_8)
  end
  def read_list
    self.read_uint32.times.map do |i|
      yield i
    end
  end
  def read_optional
    tmp = self.read_uint8
    case tmp
    when 0
      nil
    when 1
      yield
    else
      raise "Unexpected value for boolean: #{tmp}"
    end
  end
end

# vim: set tabstop=2 expandtab:
