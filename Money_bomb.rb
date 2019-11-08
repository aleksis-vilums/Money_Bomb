require 'gosu

class Player
    attr_reader :score, :alive

    def initialize
        @image = Gosu::Image.new("media/Player.png")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
    end

    def warp(x ,y)
        @x, @y = x, y
    end

    def move_right
        @x += 7
        if @x > 800
            @x = -90
        end
    end

    def move_left
        @x -= 7
        if @x < -90
            @x = 800
        end
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
        @game_over.draw(0, 0, 4)
    end

    def score
        @score
    end

    def collect_monies(monies)
        monies.reject! do |money|
            if Gosu.distance(@x, @y, money.x, money.y) < 35
                @score += 1
                true
            elsif money.y > 640
                true
            else
                false
            end
        end
    end

    def collect_larger_monies(larger_monies)
        larger_monies.reject! do |larger_money|
            if Gosu.distance(@x, @y, larger_money.x, larger_money.y) < 35
                @score += 5
                true
            elsif larger_money.y > 640
                true
            else
                false
            end
        end
    end

    def collect_bombs(bombs)
        bombs.reject! do |bomb|
            if Gosu.distance(@x, @y, bomb.x + 50, bomb.y + 50) < 35
                @alive = false
                true
            elsif bomb.y > 640
                true
            else
                false
            end
        end
    end

end

class Money
    attr_reader :x, :y

    def initialize
        @image_money = Gosu::Image.new("media/Money.png")
        @x = rand * 720 
        @y = 0
    end

    def money_fall
        @y += 3
    end

    def draw
        @image_money.draw(@x, @y, 2)
        money_fall
    end

end

class Larger_Money
    attr_reader :x, :y

    def initialize
        @image_larger_money = Gosu::Image.new("media/Large_Money.png")
        @x = rand * 720 
        @y = 0
    end

    def money_fall
        @y += 11
    end

    def draw
        @image_larger_money.draw(@x, @y, 2)
        money_fall
    end

end

class Bomb
    attr_reader :x, :y
    
    def initialize
        @image_bomb = Gosu::Image.new("media/Bomb.png")
        @x = rand * 720 
        @y = 0
    end
    
    def money_fall
        @y += 2
    end
    
    def draw
        @image_bomb.draw(@x, @y, 2)
        money_fall
    end

end

class Money_bomb < Gosu::Window
    def initialize
        super 720, 640
        self.caption = "Money Bomb"

        @background_image = Gosu::Image.new("media/Background.png")

        @player = Player.new
        @player.warp(360, 500)

        @monies = Array.new

        @larger_monies = Array.new

        @bombs = Array.new

        @font = Gosu::Font.new(20)
    end

    def update
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end

        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::KB_RIGHT
            @player.move_right
        end

        if rand(100) < 10 and @monies.size < 5
            @monies.push(Money.new)
        end

        if rand(150) < 10 and @larger_monies.size < 1
            @larger_monies.push(Larger_Money.new)
        end

        if rand(120) < 10 and @larger_monies.size < 1
            @bombs.push(Bomb.new)
        end

        @player.collect_monies(@monies)
        @player.collect_larger_monies(@larger_monies)
        @player.collect_bombs(@bombs)

    end

    def draw
        @background_image.draw(0, 0, 0)
        if @player.alive
            @player.draw
            @monies.each { |money| money.draw}
            @larger_monies.each { |larger_money| larger_money.draw}
            @bombs.each { |bomb| bomb.draw}
        else
            @font.draw_text("Press Space to restart", 300, 320, 3, 1.0, 1.0, Gosu::Color::WHITE)
            @font.draw_text("You Lost", 300, 260, 3, 1.0, 1.0, Gosu::Color::WHITE)
        end
        @font.draw_text("Score: #{@player.score}", 10, 10, 3, 1.0, 1.0, Gosu::Color::WHITE)
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end

    def button_down(id)
        if id == Gosu::KB_SPACE
            initialize
        else
            super
        end
    end
end

Money_bomb.new.show
