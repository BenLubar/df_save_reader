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

    g1a = io.read_list do io.read_uint16 end
    puts "entity[G1a] = #{g1a.inspect}"
    g1b = io.read_list do io.read_uint32 end
    puts "entity[G1b] = #{g1b.inspect}"
    raise "Unexpected size for entity[G1b]: #{g1b.size} (expected #{g1a.size})" unless g1a.size == g1b.size

    g2a = io.read_uint32
    raise "Unexpected value for entity[G2a]: #{g2a}" unless g2a == 0
    puts "entity[G2a] = #{g2a}"
    g2b = io.read_uint32
    raise "Unexpected value for entity[G2b]: #{g2b}" unless g2b == 0
    puts "entity[G2b] = #{g2b}"

    g3a = io.read_uint32
    raise "Unexpected value for entity[G3a]: #{g3a}" unless g3a == 0
    puts "entity[G3a] = #{g3a}"
    g3b = io.read_uint32
    raise "Unexpected value for entity[G3b]: #{g3b}" unless g3b == 0
    puts "entity[G3b] = #{g3b}"

    g4a = io.read_uint32
    raise "Unexpected value for entity[G4a]: #{g4a}" unless g4a == 0
    puts "entity[G4a] = #{g4a}"
    g4b = io.read_uint32
    raise "Unexpected value for entity[G4b]: #{g4b}" unless g4b == 0
    puts "entity[G4b] = #{g4b}"

    g5a = io.read_list do io.read_uint16 end
    puts "entity[G5a] = #{g5a.inspect}"
    g5b = io.read_list do io.read_uint32 end
    puts "entity[G5b] = #{g5b.inspect}"
    raise "Unexpected size for entity[G5b]: #{g5b.size} (expected #{g5a.size})" unless g5a.size == g5b.size
    g5 = g5a.zip(g5b).map do |m|
      material_for_type_and_id *m
    end
    puts "entity[G5] = #{g5.inspect}"

    puts
    raise StopIteration
  end
end

# vim: set tabstop=2 expandtab:
