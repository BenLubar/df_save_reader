require_relative 'io.rb'
require_relative 'name.rb'
require_relative 'book.rb'

open '/home/user/df_linux/data/save/adventure-ngutegróth/world.dat', 'rb' do |f|
  version = f.read_uint32
  raise "Unexpected save version #{version}" unless version == 1404
  puts "Version: #{version}"

  tmp = f.read_uint32
  case tmp
  when 0
    puts "Not compressed"
  when 1
    raise "TODO: compressed saves"
  else
    raise "Unexpected compression state: #{tmp}"
  end

  tmp = f.read_uint16
  raise "Unexpected non-zero value for field 0: #{tmp}" unless tmp == 0

  23.times do |i|
    tmp = f.read_int32
    puts "Field A-#{i + 1}: #{tmp}"
  end

  name = f.read_optional do f.read_name end
  puts "Name: #{name.inspect}"

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
  #p generated_raws

  $string_tables = Hash[[:inorganic, :plant, :body, :bodygloss, :creature, :item, :building, :entity, :word, :symbol, :translation, :color, :shape, :color_pattern, :reaction, :material_template, :tissue_template, :body_detail_plan, :creature_variation, :interaction].map do |name|
    [name, f.read_list do
      f.read_string
    end]
  end]

  #$string_tables.each do |i, table|
  #  p i, table
  #end

  puts "World full name: #{world_name}#{name}"

  tmp = Hash[f.read_list do [f.read_uint32, f.read_uint32] end]
  puts "Field B-1: (size=#{tmp.size}) #{tmp.inspect}"

  tmp = f.read_uint32
  case tmp
  when 0
    puts "Field B-2: #{tmp}"
  else
    raise "Unexpected value for field B-2: #{tmp}"
  end

  14.times do |i|
    tmp = f.read_list do f.read_uint32 end
    puts "Field B-#{i + 3}: (size=#{tmp.size}) #{tmp.inspect}"
  end

  loop.map do
   f.read_book
  end

  100.times do puts f.read_uint16.to_s(16).rjust(4, '0') end
end

# vim: set tabstop=2 expandtab:
