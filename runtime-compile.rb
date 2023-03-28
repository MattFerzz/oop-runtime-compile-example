class Console
    def initialize(output_file)
        @output_file = output_file
    end

    def write(&message)
        @output_file.puts(message.call)
    rescue
        @output_file.puts(error_message)
    ensure
        @output_file.flush
    end

    private

    def error_message
        "Oops, hubo un error. #{random_utf_emoji}"
    end

    def random_utf_emoji
        [0x1F600 + rand(80)].pack("U*")
    end
end

class Calculadora
    def dividir(a, b)
        a / b
    end 
end

console = Console.new(File.open("console.txt", "w"))
Thread.new do
    loop do
        sleep(1)
        console.write do
            Calculadora.new.dividir(3, 0)
        end
    end
end
