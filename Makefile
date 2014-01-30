output.log: adventure-ngutegróth/world.dat save.rb io.rb name.rb book.rb
	ruby save.rb | tee output.log

adventure-ngutegróth/world.dat: adventure-ngutegróth.tar.xz
	tar xmf adventure-ngutegróth.tar.xz
