require_relative 'io.rb'

class IO
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
      $string_tables[:word][i].capitalize unless i == -1
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

# vim: set tabstop=2 expandtab:
