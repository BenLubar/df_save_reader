open '/home/user/df_linux/data/save/legends-thadar-rabin/world.dat', 'rb' do |input|
  data = input.read
  data = data[data.index("\xd0\x8a\xd0\x8a\xd0\x8a\x00\x00".force_encoding(Encoding::BINARY))..-1]
  data = data[0...data.index("SUBTERRANEAN_ANIMAL_PEOPLES".force_encoding(Encoding::BINARY))]
  data = data.split("\xd0\x8a\xd0\x8a\xd0\x8a\x00\x00".force_encoding(Encoding::BINARY))[1...-1]
  data.each.with_index do |d, i|
    open "books-#{i.to_s.rjust(4, '0')}.dat", 'wb' do |output|
      output.write d
    end
  end
end

# vim: set tabstop=2 expandtab:
