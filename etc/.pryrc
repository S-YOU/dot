puts "pryrc loaded"
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

load(ENV['HOME'] + '/.irb_pry_common')

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
