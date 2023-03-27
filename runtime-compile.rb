class Console
    def initialize(output_location)
        @output_location = output_location
        @output_file = File.open(@output_location, "w")
    end

    def random_utf_emoji
        [0x1F600 + rand(80)].pack("U*")
    end
    
    def error
        "Oops, hubo un error. " + random_utf_emoji()
    end

    def write(&message)
        begin
        @output_file.write(message.call)
        rescue Exception => e
            @output_file.write(error())
        ensure    
            @output_file.flush
        end
    end

    def new_line
        @output_file.write("\n")
    end

end

@console = Console.new("console.txt")

class Calculadora
    def dividir(a, b)
            a / b
    end 

end

def run
    Thread.new do
        loop do
            sleep(1)
            @console.write do
                Calculadora.new.dividir(3,0)
            end
            @console.new_line()
        end
    end
end

run
