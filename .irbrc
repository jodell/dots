# Some default enhancements/settings for IRB, based on
# http://wiki.rubygarden.org/Ruby/page/show/Irb/TipsAndTricks

require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'

begin
  require 'wirble'
  Wirble.init(:skip_prompt => true)
  Wirble.colorize
rescue LoadError => err
  warn "Could not load Wirble: #{err}"
end

# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
require 'tempfile'

class InteractiveEditor
  attr_accessor :editor
  def initialize(editor = :vim)
    @editor = editor.to_s
    if @editor == "mate"
      @editor = "mate -w"
    end
  end
  def edit
    unless @file
      @file = Tempfile.new("irb_tempfile")
    end
    system("#{@editor} #{@file.path}")
    execute
  end
  def execute
    @file.rewind
    Object.class_eval(@file.read)
    rescue Exception => error
      puts error
  end
end

def edit(editor)
  unless IRB.conf[:interactive_editors] && IRB.conf[:interactive_editors][editor]
    IRB.conf[:interactive_editors] ||= {}
    IRB.conf[:interactive_editors][editor] = InteractiveEditor.new(editor)
  end
  IRB.conf[:interactive_editors][editor].edit
end

def vi
  edit(:vim)
end

def mate
  edit(:mate)
end

def emacs
  edit(:emacs)
end



