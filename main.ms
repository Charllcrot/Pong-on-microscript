// You will need the microstudio enviroment for run this:
// https://microstudio.dev/
// And the collision lybrary

angleToVector = function(angle)
  return [cosd(angle), sind(angle)]
end

clamp = function(value, lower_limit, upper_limit)
  local val = max(value, lower_limit)
  val = min(val, upper_limit)
  return val
end

walls = [
  object
    x = 0
    y = 104
    width = 400
    height = 20
  end,

  object
    x = 0
    y = -104
    width = 400
    height = 20
  end,
]


porterias =[
  object
    x = -200
    y = 0
    width = 10
    height = 180
    
    update = function()
      if collision(x, y, width, height, ball.x, ball.y, 10, 10) then
        points_j1 += 1
      end
    end
  end,
  object
    x = 200
    y = 0
    width = 10
    height = 180
    
    update = function()
      if collision(x, y, width, height, ball.x, ball.y, 10, 10) then
        print("FAAng")
        points_j2 += 1
      end
    end
  end
]


player1 = object
  x = -140
  y = 0
  width = 10
  height = 40
  
  update = function()
    if keyboard.W then
      y += 2
    elsif keyboard.S then
      y -= 2
    end
    
    y = clamp(y, -104, 104)
  end
  
  draw = function()
    screen.drawRect(x, y, width, height, "white")
  end
end

player2 = object
  x = 140
  y = 0
  width = 10
  height = 40
  
  update = function()
    
    if keyboard.ARROW_UP then
      y += 2
    elsif keyboard.ARROW_DOWN then
      y -= 2
    end
    
    y = clamp(y, -104, 104)
  end
  
  draw = function()
    screen.drawRect(x, y, width, height, "white")
  end
end


ball = class
  constructor = function(x, y, dir, speed)
    this.x = x
    this.y = y
    this.dir = dir
    this.speed = speed
  end
  
  update = function()
    local direction = angleToVector(this.dir)
    this.x += direction[0] * this.speed
    this.y -= direction[1] * this.speed
    
    for i in walls
      if collision(this.x, this.y, 10, 10, i.x, i.y, i.width, i.height) then
        this.dir -= 45
      end
    end
    
    //Me siento estupido
    /*for i in porterias
      if collision(this.x, this.y, 10, 10, i.x, i.y, i.width, i.height) then
        
        this.x = 0
        this.y = 0
        
        
      end
    end*/
    
    
    
    if collision(this.x, this.y, 10, 10, player1.x, player1.y, player1.width, player1.height) then
      this.dir -= 45
    end
    if collision(this.x, this.y, 10, 10, player2.x, player2.y, player2.width, player2.height) then
      this.dir -= 45
    end
  end
  
  draw = function()
    screen.drawRect(this.x, this.y, 10, 10, "white")
  end
end

init = function()
  ball = new ball(0, 0, 30, 2)
  
  points_j1 = 0
  points_j2 = 0
end

update = function()
  ball.update()
  player1.update()
  player2.update()
  /*if keyboard.R then
    ball.x = 190
    ball.y = 90
    ball.dir = 90
  end*/
  
  //for i in porterias
  if collision(ball.x, ball.y, 10, 10, porterias[0].x, porterias[0].y, porterias[0].width, porterias[0].height) then
    
    ball.x = 0
    ball.y = 0
    
    points_j1 += 1 
  end
  if collision(ball.x, ball.y, 10, 10, porterias[1].x, porterias[1].y, porterias[1].width, porterias[1].height) then
    
    ball.x = 0
    ball.y = 0
    
    points_j2 += 1 
  end
end

draw = function()
  screen.clear()
  ball.draw()
  for i in walls
    screen.drawRect(i.x, i.y, i.width, i.height, "white")
  end
  
  for i in porterias
    screen.drawRect(i.x, i.y, i.width, i.height, "white")
  end
  
  player1.draw()
  player2.draw()
  
  screen.drawText(points_j1, -50, 70, 10, "white")
  screen.drawText(points_j2, 50, 70, 10, "white")
  screen.drawText(system.fps, 0, 0, 20, "white")
end
