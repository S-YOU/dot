# gem install pry pry-byebug pry-stack_explorer
#
# binding.pry   と書くことでpry起動
#
# whereami (@)  今いるところのソースコードを表示する。@ 10で前後10行を表示
# edit -c       エディタでソースを編集する
#

if defined?(PryByebug)
  Pry.commands.alias_command 'br', 'break'
  Pry.commands.alias_command 'st', 'step'
  Pry.commands.alias_command 'nx', 'next'
  Pry.commands.alias_command 'fin', 'finish'
  Pry.commands.alias_command 'fr', 'frame'
  Pry.commands.alias_command 'cont', 'continue'
  Pry.commands.alias_command 'ed', 'edit -c'
  Pry.commands.alias_command 'b', 'break'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
end

Pry.commands.alias_command 'bt', 'pry-backtrace'

# エンターで直前のコマンドを繰り返し実行できるようにする
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.run_command Pry.history.to_a.last
end

# pry-rescueはいくつか問題がある
# ・pry-byebugと相性が悪く、nなどのコマンドを使うと落ちる
# ・try-againはスクリプトを最初から実行し直すので、あまり便利でない
# よってインストールしないようにする

#Pry.plugins["stack_explorer"].disable!

def reload
  if !defined?($last_loaded)
    puts "No file loaded yet."
    return
  end
  puts "Reloading: #{$last_loaded}"
  load($last_loaded)
end

alias _orig_loaded load
def load(file, priv = false) 
  _orig_loaded(file, priv)
  $last_loaded = file
end

class Integer
  def comma(delim = ",")
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1' + delim)
  end
end

# from "yen" gem
class Integer
  def to_yen(type = :positional)
    self.to_j(type) + "円"
  end

  def to_j(type = :positional)
    cardinal = %w(零 一 二 三 四 五 六 七 八 九)
    base_unit = %w(十 百 千)
    unit = %w(万 億 兆 京 垓 予 穣 溝 澗 正 裁 極 恒河沙 阿僧祇 那由多 不可思議 無量大数)
    float_unit = %w(割 分 厘 毛 糸 忽 微 繊 沙 塵 埃 緲 漠 模糊 逡巡 須臾 瞬息 断指 刹那 六徳 虚 空 清 浄)

    return (type == :positional)? "0" : "零" if self.zero?

    numbers = []

    self.to_s.chars{ |num| numbers.unshift num.to_i }

    number_blocks = numbers.each_slice(4).to_a.reverse

    japanese = ""
    block_size = number_blocks.size

    number_blocks.each_with_index do |block, index|
      str = ""
      if type == :positional 
        num = block.reverse.join.to_i
        str += num.to_s unless num.zero?
      else
        block.each_with_index do |num, unit|
          if num.nonzero? 
            str += base_unit[unit-1] if unit.nonzero?

            if num == 1
              if unit.zero? || unit == 3
                if index != block_size-1 || str.size.zero?
                  str += cardinal[num] 
                end
              end
            else
              str += cardinal[num]
            end
          end
        end
      end

      japanese += (type == :all)? str.reverse : str
      japanese += unit[number_blocks.size-(index+2)] if str.size.nonzero? && block_size != index+1
    end

    japanese
  end

  alias jp to_j
end

def h2d(hex)
  printf "%d\n", hex.to_i
end
    
def d2h(dec)
  printf "0x%02x\n", dec.to_i
end
