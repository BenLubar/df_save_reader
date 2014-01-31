require_relative 'io.rb'
require_relative 'name.rb'
require_relative 'book.rb'
require_relative 'entity.rb'

def material_for_type_and_id type, id
  case type
  when 0
    $string_tables[:inorganic][id].downcase
  when 3
    raise "Unexpected value for material[ID]: #{id} (expected -1)" unless id == -1
    "green glass"
  when 4
    raise "Unexpected value for material[ID]: #{id} (expected -1)" unless id == -1
    "clear glass"
  when 5
    raise "Unexpected value for material[ID]: #{id} (expected -1)" unless id == -1
    "crystal glass"
  when 21, 22
    $string_tables[:creature][id].downcase + " bone"
  when 23
    $string_tables[:creature][id].downcase + " cartilage"
  when 25
    $string_tables[:creature][id].downcase + " tooth"
  when 35
    $string_tables[:creature][id].downcase + " spleen"
  when 36, 37, 38
    $string_tables[:creature][id].downcase + " leather"
  when 39
    $string_tables[:creature][id].downcase + " shell"
  when 40
    $string_tables[:creature][id].downcase + " feather"
  when 41
    $string_tables[:creature][id].downcase + " hoof"
  when 42
    $string_tables[:creature][id].downcase + " ivory"
  when 420
    $string_tables[:plant][id].downcase + " wood"
  when 421
    $string_tables[:plant][id].downcase + " fiber"
  else
    raise "Unexpected value for material[Type]: #{type}"
  end
end

open 'adventure-ngutegróth/world.dat', 'rb' do |f|
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

  $generated_raws = Hash[[:inorganic, :item, :creature, :interaction].map do |name|
    [name, f.read_list do
      f.read_list do
        f.read_string
      end
    end]
  end]
  $generated_raws.each do |i, raws|
    p i, raws
  end

  $string_tables = Hash[[:inorganic, :plant, :body, :bodygloss, :creature, :item, :building, :entity, :word, :symbol, :translation, :color, :shape, :color_pattern, :reaction, :material_template, :tissue_template, :body_detail_plan, :creature_variation, :interaction].map do |name|
    [name, f.read_list do
      f.read_string
    end]
  end]

  $string_tables.each do |i, table|
    p i, table
  end

  $generated_raws.each do |i, raws|
    raws.each do |raw|
      $string_tables[i] << raw[2].gsub(/^\[[A-Z]+:|\]$/, '')
    end
  end

  puts "World full name: #{world_name}#{name}"

  artifact_ids = Hash[f.read_list do [f.read_uint32, f.read_uint32] end]
  puts "Field B-1: (artifact ids) (size=#{artifact_ids.size}) #{artifact_ids.inspect}"

  tmp = f.read_uint32
  case tmp
  when 0
    puts "Field B-2: #{tmp}"
  else
    raise "Unexpected value for field B-2: #{tmp}"
  end

  entity_ids = f.read_list do f.read_uint32 end
  puts "Field B-3: (entity ids) (size=#{entity_ids.size}) #{entity_ids.inspect}"

  13.times do |i|
    tmp = f.read_list do f.read_uint32 end
    puts "Field B-#{i + 4}: (size=#{tmp.size}) #{tmp.inspect}"
  end

  loop.map do
   f.read_book
  end

  loop.map do
   f.read_entity
  end

  100.times do puts f.read_uint16.to_s(16).rjust(4, '0') end
end

# vim: set tabstop=2 expandtab:
