require 'set'

class Raws
  attr_reader :words
  attr_reader :symbols
  attr_reader :translations
  attr_reader :creatures

  def initialize dir
    @words = {}
    @symbols = {}
    @translations = {}
    @creatures = {}

    Dir["#{dir}/raw/objects/*.txt"].each do |fn|
      open fn, 'r:CP437' do |f|
        data = f.read.encode(Encoding::UTF_8).split(/(\[[^\[\]]+\])/).reject do |s| s[0] != '[' end
        case data[0]
        when '[OBJECT:LANGUAGE]'
          translation = nil
          symbol = nil
          word = nil
          data[1..-1].each do |r|
            case r
            when /\A\[TRANSLATION:([^:\]]*)\]\z/
              translation = {}
              raise "Duplicate TRANSLATION:#{$1}" if @translations[$1]
              @translations[$1] = translation
              symbol = nil
              word = nil
            when /\A\[T_WORD:([^:\]]*):([^:\]]*)\]\z/
              raise "Duplicate T_WORD:#{$1}" if translation[$1]
              translation[$1] = $2

            when /\A\[SYMBOL:([^:\]]*)\]\z/
              symbol = Set.new
              raise "Duplicate SYMBOL:#{$1}" if @symbols[$1]
              @symbols[$1] = symbol
              translation = nil
              word = nil
            when /\A\[S_WORD:([^:\]]*)\]\z/
              raise "Duplicate S_WORD:#{$1}" if symbol.include? $1
              symbol.add $1

            when /\A\[WORD:([^:\]]*)\]\z/
              word = Word.new $1
              raise "Duplicate WORD:#{word.id}" if @words[word.id]
              @words[word.id] = word
              translation = nil
              symbol = nil
            when /\A\[NOUN:([^:\]]*):([^:\]]*)\]\z/
              raise "Duplicate NOUN:#{word.id}" if word.noun_singular
              word.noun_singular = $1
              word.noun_plural = $2
            when /\A\[ADJ:([^:\]]*)\]\z/
              raise "Duplicate ADJECTIVE:#{word.id}" if word.adjective
              word.adjective = $1
            when /\A\[PREFIX:([^:\]]*)\]\z/
              raise "Duplicate PREFIX:#{word.id}" if word.prefix
              word.prefix = $1
            when /\A\[VERB:([^:\]]*):([^:\]]*):([^:\]]*):([^:\]]*):([^:\]]*)\]\z/
              raise "Duplicate VERB:#{word.id}" if word.verb_base
              word.verb_base = $1
              word.verb_present = $2
              word.verb_past = $3
              word.verb_past_part = $4
              word.verb_present_part = $5
            when /\A\[(
                    ((FRONT|REAR|THE)_COMPOUND|THE|OF)_NOUN_(SING|PLUR)|
                    (FRONT|REAR|THE)_COMPOUND_(ADJ|PREFIX)|
                    STANDARD_VERB
            )\]\z/x
              raise "Duplicate #{$1}:#{word.id}" if word.send :"#{$1.downcase}"
              word.send :"#{$1.downcase}=", true
            when /\A\[ADJ_DIST:([1-7])\]\z/
              raise "Duplicate ADJ_DIST:#{word.id}" if word.adj_dist
              word.adj_dist = $1.to_i
            else
              raise "Unknown word token: #{r}"
            end
          end
        when '[OBJECT:CREATURE]'
          creature = nil
          data[1..-1].each do |r|
            case r
            when /\A\[CREATURE:([^:\]]*)\]\z/
              creature = Creature.new $1
              raise "Duplicate CREATURE:#{creature.id}" if @creatures[creature.id]
              @creatures[creature.id] = creature
            when /\A\[NAME:([^:\]]*):([^:\]]*):([^:\]]*)\]\z/
              raise "Duplicate NAME:#{creature.id}" if creature.name_sing
              creature.name_sing = $1
              creature.name_plur = $2
              creature.name_adj = $3
            when /\A\[CASTE_NAME:([^:\]]*):([^:\]]*):([^:\]]*)\]\z/
              raise "Duplicate CASTE_NAME:#{creature.id}" if creature.caste_name_sing
              creature.caste_name_sing = $1
              creature.caste_name_plur = $2
              creature.caste_name_adj = $3
            when /\A\[DESCRIPTION:([^:\]]*)\]\z/
              raise "Duplicate DESCRIPTION:#{creature.id}" if creature.description
              creature.description = $1
            when /\A\[CREATURE_TILE:'\\?([^:\]])'\]\z/
              raise "Duplicate DESCRIPTION:#{creature.id}" if creature.tile
              creature.tile = $1
            when /\A\[CREATURE_TILE:([0-9]+)\]\z/
              raise "Duplicate DESCRIPTION:#{creature.id}" if creature.tile
              creature.tile = ("" << $1.to_i).force_encoding(Encoding::CP437).encode(Encoding::UTF_8)
            else
              raise "Unknown creature token: #{r}"
            end
          end
        else
          raise "Unknown object type: #{data[0]}"
        end
      end
    end
  end

  class Word
    attr_reader   :id
    attr_accessor :noun_singular
    attr_accessor :noun_plural
    attr_accessor :adjective
    attr_accessor :prefix
    attr_accessor :verb_base
    attr_accessor :verb_present
    attr_accessor :verb_past
    attr_accessor :verb_past_part
    attr_accessor :verb_present_part

    attr_accessor :front_compound_noun_sing
    attr_accessor :front_compound_noun_plur
    attr_accessor :rear_compound_noun_sing
    attr_accessor :rear_compound_noun_plur
    attr_accessor :the_compound_noun_sing
    attr_accessor :the_compound_noun_plur
    attr_accessor :the_noun_sing
    attr_accessor :the_noun_plur
    attr_accessor :of_noun_sing
    attr_accessor :of_noun_plur
    attr_accessor :front_compound_adj
    attr_accessor :front_compound_prefix
    attr_accessor :rear_compound_adj
    attr_accessor :rear_compound_prefix
    attr_accessor :the_compound_adj
    attr_accessor :the_compound_prefix
    attr_accessor :standard_verb
    attr_accessor :adj_dist

    def initialize id
      @id = id
    end
  end

  class Creature
    attr_reader   :id
    attr_accessor :name_sing
    attr_accessor :name_plur
    attr_accessor :name_adj
    attr_accessor :caste_name_sing
    attr_accessor :caste_name_plur
    attr_accessor :caste_name_adj
    attr_accessor :description
    attr_accessor :tile

    def initialize id
      @id = id
    end
  end
end

$raws = Raws.new 'adventure-ngutegróth'

# vim: set tabstop=2 expandtab:
