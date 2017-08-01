# vim: set ft=ruby:

# 直前の計算結果を保持する変数 _ を有効にする
IRB.conf[:EVAL_HISTORY] = 1000 
IRB.conf[:SAVE_HISTORY] = 100 

# ヒストリーを有効にする
HISTFILE = "~/.irb.hist"
MAXHISTSIZE = 100
   
begin
  if defined? Readline::HISTORY
    histfile = File::expand_path( HISTFILE )
    if File::exists?( histfile )
      lines = IO::readlines( histfile ).collect {|line| line.chomp}
      puts "Read %d saved history commands from %s." %
        [ lines.nitems, histfile ] if $DEBUG || $VERBOSE
      Readline::HISTORY.push( *lines )
    else
      puts "History file '%s' was empty or non-existant." %
        histfile if $DEBUG || $VERBOSE
    end

    Kernel::at_exit {
      lines = Readline::HISTORY.to_a.reverse.uniq.reverse
      lines = lines[ -MAXHISTSIZE, MAXHISTSIZE ] if lines.nitems > MAXHISTSIZE
      $stderr.puts "Saving %d history lines to %s." %

        [ lines.length, histfile ] if $VERBOSE || $DEBUG
      File::open( histfile, File::WRONLY|File::CREAT|File::TRUNC ) {|ofh|
        lines.each {|line| ofh.puts line }
      }
    }
  end
end

# タブ補完を有効にする
require 'irb/completion'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

class Integer
  def number_with_delimiter(delim = ",")
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1' + delim)
  end

  alias comma number_with_delimiter
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

