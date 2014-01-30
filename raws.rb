class Raws
  attr_accessor :translations
  def initialize dir
    @words = {}
    @translations = {}
    Dir["#{dir}/raw/objects/*.txt"].each do |fn|
      open fn, 'r:CP437' do |f|
        data = f.read.encode(Encoding::UTF_8).split(/(\[[^\[\]]+\])/).reject do |s| s[0] != '[' end
        case data[0]
        when '[OBJECT:LANGUAGE]'
          case data[1]
          when /^\[TRANSLATION:([^:\]]+)\]$/
            name = $1
            @translations[name] = Hash[data[2..-1].map do |r|
              raise "Expected T_WORD but got: #{r}" unless r =~ /^\[T_WORD:([^:\]]+):([^:\]]+)\]$/
              [$1, $2]
            end]
          when /^\[WORD:([^:\]]+)\]$/
            word = nil
            data[1..-1].each do |r|
              case r
              when /^\[WORD:([^:\]]+)\]$/
                word = Word.new $1
                @words[word.id] = word
              when /^\[NOUN:([^:\]]+):([^:\]]+)\]$/
                word.noun_singular = $1
                word.noun_plural = $2
              when /^\[ADJ:([^:\]]+)\]$/
                word.adjective = $1
              when /^\[(FRONT_COMPOUND_NOUN_SING|REAR_COMPOUND_NOUN_SING|THE_NOUN_SING|REAR_COMPOUND_NOUN_PLUR|THE_NOUN_SING|THE_NOUN_SING|OF_NOUN_PLUR|FRONT_COMPOUND_ADJ|THE_COMPOUND_ADJ)\]$/
                word.send :"#{$1.downcase}=", true
              when /^\[ADJ_DIST:([1-5])\]$/
                word.adj_dist = $1.to_i
              else
                raise "Unknown word token: #{r}"
              end
            end
          else
            raise "Unknown language type: #{data[1]}"
          end
        else
          puts "Unknown object type: #{data[0]}"
        end
      end
    end
  end

  class Word
    attr_accessor :id
    attr_accessor :noun_singular
    attr_accessor :noun_plural
    attr_accessor :adjective
    attr_accessor :adj_dist

    attr_accessor :front_compound_noun_sing
    attr_accessor :rear_compound_noun_sing
    attr_accessor :the_noun_sing
    attr_accessor :rear_compound_noun_plur
    attr_accessor :of_noun_plur
    attr_accessor :the_noun_sing
    attr_accessor :of_noun_plur
    attr_accessor :front_compound_adj
    attr_accessor :the_compound_adj

    def initialize id
      @id = id
    end
  end
end

$raws = Raws.new '/home/user/df_linux/data/save/adventure-ngutegróth'

# vim: set tabstop=2 expandtab:
