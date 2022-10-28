require 'ruby2d'

set background: 'navy'

# slowing down the frame to one frame per second

set fps_cap: 10


#break down the screen into grid boxes
# width of our window = 640/20 = 32
# height = 480/20 =24

GRID_SIZE = 20
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE

# create a snake class with an initializer
class Snake
# set the direction

    attr_writer :direction

    def initialize

        # create an array called positions
        # will hold each of the squares the snake occupies
        # will give a set of arrays inside the array that will have the x -y coordinates

        @positions = [[2,0], [2,1], [2,2], [2,3]]

        # update the positions array
        # set a starting direction

        @direction = 'down'
        @growing = false
    end

        # draw a square for each of these positions
        # create a draw method

        def draw

            #loop through each of the positions

            @positions.each do |position|

                # draw

                Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE - 1, color: 'white')
        end
    end
    
    def move
        if !@growing
        # remove
        @positions.shift
        end

        case @direction
        when 'down'
            #add
            @positions.push(new_coords(head[0], head[1] + 1 ) )
        when 'up'
            @positions.push(new_coords(head[0], head[1] - 1 )) 
        when 'left'
            @positions.push(new_coords(head[0] - 1, head[1]))
        when 'right'
            @positions.push(new_coords(head[0] + 1, head[1]))
    end
    @growing = false
end

def can_change_direction_to?(new_direction)
    case @direction
    when 'up' then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end
    # @growing = false
end

def x
    head[0]
end

def y
    head[1]
end

def grow
    @growing = true
end

def hit_itself?
    #use uniq method
  @positions.uniq.length != @positions.length
end

private

def new_coords(x,y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
end

def head
    @positions.last
end
end

class Game
    def initialize
        @score = 0
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
        @finished = false

    end

    def draw
        unless finished?
            Square.new(x: @food_x * GRID_SIZE, y: @food_y * GRID_SIZE, size: GRID_SIZE - 1, color: 'yellow')
        end
            Text.new(text_message, color: 'green', x: 10, y: 10, size: 25)
    end
# end

    def snake_eat_food?(x,y)
        @food_x == x && @food_y == y
    end
# end

    def record_eat
        @score += 1
        @food_x = rand(GRID_WIDTH)
        @food_y =rand(GRID_HEIGHT)
    end

    def finish
        # puts 'finishing game'
        @finished = true
    end

    def finished?
        @finished
    end

    private

    def text_message
        if finished?
            "Game Over, your score is: #{@score}. Press 'R' to restart."
        else
            "Score: #{@score}"
        end
    end
end


# create snake and  call draw
snake = Snake.new
game = Game.new
# snake.draw

update do
    clear

    unless game.finished?
        snake.move
    end
        
    # end
    # snake.move
    snake.draw
    game.draw

    if game.snake_eat_food?(snake.x, snake.y)
        game.record_eat
        snake.grow
    end

    if snake.hit_itself?
        game.finish
    end
end

#adding events
on :key_down do |event|

    # print out which key has been pressedon the keyboard
    # puts event.key

    if ['up', 'down', 'left', 'right'].include?(event.key)
        if snake.can_change_direction_to?(event.key)
        snake.direction = event.key
        end
    elsif event.key == 'r'
        snake = Snake.new
        game = Game.new
    end
end

# end
show

# @Code with Mario