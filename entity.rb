require_relative 'io.rb'

class IO
  def read_entity
    Entity.new self
  end
end

class Entity
  def initialize io
    a = io.read_int16
    raise "Unexpected value for entity[A]: #{a}" unless a == 0
    puts "entity[A] = #{a}"

    id = io.read_uint32
    puts "entity[ID] = #{id}"

    type = io.read_string
    raise "Unexpected value for entity[Type]: #{type}" unless $string_tables[:entity].include? type
    puts "entity[Type] = #{type.inspect}"

    b = io.read_int16
    puts "entity[B] = #{b}"
    c = io.read_int16
    puts "entity[C] = #{c}"
    d = io.read_int32
    puts "entity[D] = #{d}"
    e = io.read_uint16
    puts "entity[E] = #{e}"

    name = io.read_optional do io.read_name end
    puts "entity[Name] = #{name.inspect}"

    species = $string_tables[:creature][io.read_uint32]
    puts "entity[Species] = #{species.inspect}"

    f = io.read_int16
    raise "Unexpected value for entity[F]: #{f}" unless f == 0
    puts "entity[F] = #{f}"

    g = 18.times.map do |g|
      ga = io.read_list do io.read_uint16 end
      puts "entity[G#{g}a] = #{ga.inspect}"
      gb = io.read_list do io.read_uint32 end
      puts "entity[G#{g}b] = #{gb.inspect}"
      raise "Unexpected size for entity[G#{g}b]: #{gb.size} (expected #{ga.size})" unless ga.size == gb.size
      g_ = ga.zip(gb).map do |m|
        material_for_type_and_id *m
      end
      puts "entity[G#{g}] = #{g_.inspect}"
      g_
    end

    puts
    raise StopIteration
  end
end

# vim: set tabstop=2 expandtab:
