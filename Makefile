output.log: thur-num/world.dat save.rb io.rb name.rb book.rb entity.rb
	ruby save.rb 2>&1 | tee output.log

thur-num/world.dat: thur-num.tar.xz
	tar xmf thur-num.tar.xz
