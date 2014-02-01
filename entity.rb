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
    puts "entity[Name] = #{name.inspect} #{name}"

    species = $string_tables[:creature][io.read_uint32]
    puts "entity[Species] = #{species.inspect}"

    f = io.read_int16
    raise "Unexpected value for entity[F]: #{f}" unless f == 0
    puts "entity[F] = #{f}"

    g = 18.times.map do |g|
      ga = io.read_list do io.read_int16 end
      puts "entity[G#{g}a] = #{ga.inspect}"
      gb = io.read_list do io.read_int32 end
      puts "entity[G#{g}b] = #{gb.inspect}"
      raise "Unexpected size for entity[G#{g}b]: #{gb.size} (expected #{ga.size})" unless ga.size == gb.size
      g_ = ga.zip(gb).map do |m|
        material_for_type_and_id *m
      end
      puts "entity[G#{g}] = #{g_.inspect}"
      g_
    end

    h_a = 2.times.map do |h|
      ha = io.read_list do io.read_uint32 end
      puts "entity[HA#{h}a] = #{ha.inspect}"
      hb = io.read_list do
        tmp = io.read_uint16
        case tmp
        when 0
          false
        when 1
          true
        else
          raise "Unexpected value for HA#{h}b: #{tmp}"
        end
      end
      puts "entity[HA#{h}b] = #{hb.inspect}"
      raise "Unexpected size for entity[HA#{h}b]: #{hb.size} (expected #{ha.size})" unless ha.size == hb.size
      [ha, hb]
    end

    h_b = 3.times.map do |h|
      h_ba = io.read_list do io.read_int16 end
      puts "entity[HB#{h}a] = #{h_ba.inspect}"
      h_bb = io.read_list do io.read_int32 end
      puts "entity[HB#{h}b] = #{h_bb.inspect}"
      [h_ba, h_bb]
    end
    h_b[3] = io.read_int32
    puts "entity[HB3] = #{h_b[3]}"
    raise "Unexpected value for entity[HB3]: #{h_b[3]}" unless [0, 0x0007000a].include? h_b[3]
    h_b[4] = io.read_list do io.read_int32 end
    puts "entity[HB4] = #{h_b[4].inspect}"

    h_c = 7.times.map do |h|
      ha = io.read_list do io.read_uint32 end
      puts "entity[HC#{h}a] = #{ha.inspect}"
      hb = io.read_list do
        tmp = io.read_uint16
        case tmp
        when 0
          false
        when 1
          true
        else
          raise "Unexpected value for HC#{h}b: #{tmp}"
        end
      end
      puts "entity[HC#{h}b] = #{hb.inspect}"
      raise "Unexpected size for entity[HC#{h}b]: #{hb.size} (expected #{ha.size})" unless ha.size == hb.size
      [ha, hb]
    end

    i = 1.times.map do |i|
      ia = io.read_list do io.read_int16 end
      puts "entity[I#{i}a] = #{ia.inspect}"
      ib = io.read_list do io.read_int32 end
      puts "entity[I#{i}b] = #{ib.inspect}"
      raise "Unexpected size for entity[I#{i}b]: #{ib.size} (expected #{ia.size})" unless ia.size == ib.size
      i_ = ia.zip(ib).map do |m|
        material_for_type_and_id *m
      end
      puts "entity[I#{i}] = #{i_.inspect}"
      i_
    end
 
    j = 3.times.map do |j|
      tmp = io.read_list do io.read_int32 end
      puts "entity[J#{j}] = #{tmp}"
      tmp
    end

    k = 9.times.map do |k|
      ka = io.read_list do io.read_int16 end
      puts "entity[K#{k}a] = #{ka.inspect}"
      kb = io.read_list do io.read_int32 end
      puts "entity[K#{k}b] = #{kb.inspect}"
      raise "Unexpected size for entity[K#{k}b]: #{kb.size} (expected #{ka.size})" unless ka.size == kb.size
      k_ = ka.zip(kb).map do |m|
        material_for_type_and_id *m
      end
      puts "entity[K#{k}] = #{k_.inspect}"
      k_
    end

    l = 3.times.map do |l|
      la = io.read_int16
      puts "entity[L#{l}a] = #{la}"
      #raise "Unexpected value for entity[L#{l}a]: #{la} (expected -1)" unless la == -1
      lb = io.read_int32
      puts "entity[L#{l}b] = #{lb}"
      #raise "Unexpected value for entity[L#{l}b]: #{lb} (expected 0)" unless lb == 0
      [la, lb]
    end

    m = 17.times.map do |m|
      tmp = io.read_list do io.read_int16 end
      puts "entity[M#{m}] = #{tmp.inspect}"
      tmp
    end

    if h_b[3] == 0x0007000a
      m_b = 5.times.map do |m|
        tmp = io.read_int16
        puts "entity[MB#{m}] = #{tmp}"
        tmp
      end
    end

    n = 9.times.map do |n|
      na = io.read_list do io.read_int16 end
      puts "entity[N#{n}a] = #{na.inspect}"
      nb = io.read_list do io.read_int32 end
      puts "entity[N#{n}b] = #{nb.inspect}"
      raise "Unexpected size for entity[N#{n}b]: #{nb.size} (expected #{na.size})" unless na.size == nb.size
      n_ = na.zip(nb).map do |m|
        material_for_type_and_id *m
      end
      puts "entity[N#{n}] = #{n_.inspect}"
      n_
    end

    o = []
    o[0] = io.read_uint32
    puts "entity[O0] = #{o[0]}"
    raise "Unexpected value for entity[O0]: #{o[0]} (expected 0)" unless o[0] == 0
    o[1] = io.read_uint32
    puts "entity[O1] = #{o[1]}"
    raise "Unexpected value for entity[O1]: #{o[1]} (expected 0)" unless o[1] == 0
    o[2] = io.read_uint32
    puts "entity[O2] = #{o[2]}"
    raise "Unexpected value for entity[O2]: #{o[2]} (expected 0)" unless o[2] == 0
    o[3] = io.read_list do io.read_uint32 end
    puts "entity[O3] = #{o[3].inspect}"
    o[4] = io.read_uint32
    puts "entity[O4] = #{o[4]}"
    raise "Unexpected value for entity[O4]: #{o[4]} (expected 0)" unless o[4] == 0

    p = []
    pa = io.read_list do io.read_int16 end
    puts "entity[P0a] = #{pa.inspect}"
    pb = io.read_list do io.read_int32 end
    puts "entity[P0b] = #{pb.inspect}"
    raise "Unexpected size for entity[P0b]: #{pb.size} (expected #{pa.size})" unless pa.size == pb.size
    p[0] = pa.zip(pb).map do |m|
      material_for_type_and_id *m
    end
    puts "entity[P0] = #{p[0].inspect}"

    pa = io.read_list do io.read_int16 end
    puts "entity[P1a] = #{pa.inspect}"
    pb = io.read_list do io.read_int32 end
    puts "entity[P1b] = #{pb.inspect}"
    raise "Unexpected size for entity[P1b]: #{pb.size} (expected #{pa.size})" unless pa.size == pb.size
    p[1] = [pa, pb]
    # TODO: are these materials?

    q = io.read_uint16
    puts "entity[Q] = #{q}"

    r_expected = [0x0001, 0x0000, nil, 0x0000, [0x0000, 0x0100], 0x0001, 0x0000, nil, 0x0001, 0x0000, nil, 0x0000, 0x0000, 0x0000, 0x0000, 0xffff, 0xffff, 0xffff, nil, nil, 0xffff, 0xffff, 0xffff, 0xffff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0003, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0d00, 0x0100, 0x0100, 0x0100, 0x0100, 0x0f00, 0x0000, 0x0100, 0x0f00, 0x0f00, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0200, 0x0f00, 0x0f00, 0x0f00, 0x0f00, 0x0f00, 0x0f00, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xff00, 0xffff, 0x00ff, 0x0000, 0xff00, 0xffff, 0x00ff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000]

    r = r_expected.map.with_index do |expected, r|
      tmp = io.read_uint16
      puts "entity[R#{r}] = #{tmp}"
      case expected
      when nil
        # no verification
      when Array
        raise "Unexpected value for entity[R#{r}]: #{tmp} (expected #{expected})" unless expected.include? tmp
      else
        raise "Unexpected value for entity[R#{r}]: #{tmp} (expected #{expected})" unless tmp == expected
      end
      tmp
    end

    puts
  end
end

# vim: set tabstop=2 expandtab:
