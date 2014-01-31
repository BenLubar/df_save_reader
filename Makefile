output.log: adventure-ngutegróth/world.dat save.rb io.rb name.rb book.rb entity.rb
	ruby save.rb 2>&1 | tee output.log

adventure-ngutegróth/world.dat: adventure-ngutegróth.tar.xz
	tar xmf adventure-ngutegróth.tar.xz
