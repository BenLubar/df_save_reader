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
      raise Exception, "Unexpected value for boolean: #{tmp}"
    end
  end
  def read_name
    Name.new self
  end
end

class Name
  attr_accessor :first_name
  attr_accessor :nickname
  attr_accessor :word_index
  attr_accessor :word_form
  attr_accessor :language

  def initialize io
    @first_name = io.read_string
    @nickname   = io.read_string
    @word_index = 7.times.map do io.read_int32  end
    @word_form  = 7.times.map do io.read_uint16 end
    @language   = io.read_int32
    io.read_int16 # just discard the unknown value for now
  end

  def to_s
    # TODO: word forms and languages

    words = @word_index.map do |i|
      $word_string_table[i].capitalize unless i == -1
    end

    name = ""
    name << first_name
    name << ' "' << nickname << '"' unless nickname.empty?
    name << ' ' << words[0] << words[1] if words[0] or words[1]
    if words[5]
      name << ' the'
      name << ' ' << words[2] if words[2]
      name << ' ' << words[3] if words[3]
      name << ' '
      name << words[4] << '-' if words[4]
      name << words[5]
    end
    name << ' of ' << words[6] if words[6]

    name
  end
end

open '/home/user/df_linux/data/save/adventure-ngutegróth/world.dat', 'rb' do |f|
  version = f.read_uint32
  raise Exception, "Unexpected save version #{version}" unless version == 1404
  puts "Version: #{version}"

  tmp = f.read_uint32
  case tmp
  when 0
    puts "Not compressed"
  when 1
    raise Exception, "TODO: compressed saves"
  else
    raise Exception, "Unexpected compression state: #{tmp}"
  end

  tmp = f.read_uint16
  raise Exception, "Unexpected non-zero value for field 0: #{tmp}" unless tmp == 0

  23.times do |i|
    tmp = f.read_int32
    puts "Field A-#{i + 1}: #{tmp}"
  end

  name = f.read_optional do f.read_name end
  p name

  tmp = f.read_uint8
  puts "Field A-24: #{tmp}"

  tmp = f.read_int16
  puts "Field A-25: #{tmp}"

  3.times do |i|
    tmp = f.read_int32
    puts "Field A-#{i + 26}: #{tmp}"
  end

  world_name = f.read_string
  puts "World name: #{world_name}"

  generated_raws = 4.times.map do
    f.read_list do
      f.read_list do
        f.read_string
      end
    end
  end
  p generated_raws

  string_tables = 20.times.map do
    f.read_list do
      f.read_string
    end
  end
  $word_string_table = string_tables[8]

  string_tables.each.with_index do |table, i|
    p i, table
  end

  puts "World full name: #{world_name}#{name}"

  100.times do puts f.read_uint16.to_s(16) end
end

# vim: set tabstop=2 expandtab:
