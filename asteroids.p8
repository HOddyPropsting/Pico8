pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function sort(t)
 for i=1,#t do
  j = i
  while j > 1 and t[j-1] > t[j] do
  	x = t[j-1]
  	t[j-1] = t[j]
  	t[j] = x
  	j -= 1
  end 
 end
end

function generate_asteroid()
 t = {}
 a = {}
 for i=0,20 do
  add(t,rnd(1))
 end
 sort(t)
 for i=0,#t do
  add(a,{cos(t[i])*(rnd(10)+5),sin(t[i])*(rnd(10)+5)})
 end
 return a
end

ship = {
 x=10,
 y=10,
 r=0.0,
 speed=0,
 friction=0.999,
 mx=0,
 my=0,
 shotcd=1,
 body = {
  {-2,-5},
  {2,-5},
  {4,5},
  {1,2},
  {-2,2},
  {-4,5},
 }
}

function draw_ship()
 x = ship.x
 y = ship.y
 cosr = cos(ship.r)
 sinr = sin(ship.r)
 for i,p in pairs(ship.body) do
  sx = p[1]
  sy = p[2]
  l = i
  if i == #ship.body then
   l = 1
  else
   l = i+1
  end
  dx = ship.body[l][1]
  dy = ship.body[l][2]
  
  sxx = (cosr*sx) - (sinr*sy)
  syy = (sinr*sx) + (cosr*sy)
  dxx = (cosr*dx) - (sinr*dy)
  dyy = (sinr*dx) + (cosr*dy)
  line(sxx+x,syy+y,dxx+x,dyy+y)
 end
end

ast = generate_asteroid()


function _update()
 if btn(0) then ship.r += 0.01 end
 if btn(1) then ship.r -= 0.01 end
 if btn(2) then ship.speed += 0.01 end
 if btn(4) then shoot() end
 ship.x = ship.x + ship.speed*sin(ship.r)
 ship.y = ship.y - ship.speed*cos(ship.r)
 ship.speed = ship.speed*ship.friction
 if ship.shotcd > 0 then ship.shotcd -= 0.06 end
	if ship.x > 128 then ship.x = 0 end
	if ship.y > 128 then ship.y = 0 end
	if ship.x < 0 then ship.x = 128 end
	if ship.y < 0 then ship.y = 128 end
	for b in all(bullets) do
		b.x += b.dx
		b.y += b.dy
		if b.x > 128 then b.x = 0 end
		if b.y > 128 then b.y = 0 end
		if b.x < 0 then b.x = 128 end
		if b.y < 0 then b.y = 128 end
	end
	
end
 
 


function _draw()
 cls()
 draw_ship()
 for i,p in pairs(ast) do
  e = {}
  if i == #ast then
   e = ast[1]
  else
   e = ast[i+1]
  end
  line(64+p[1],64+p[2],64+e[1],64+e[2])
 end
 
 draw_bullets()
 
 
 print(cos(ship.r),80,100)
 print(sin(ship.r),80,120)
 print("x: "..ship.x,40,80)
 print("y: "..ship.y,40,90)
end

bullets = {}

function shoot()
	if ship.shotcd < 0 then
		add(bullets,{x=ship.x,y=ship.y,dx=sin(ship.r),dy=-cos(ship.r)})
		ship.shotcd = 1
	end
end

function draw_bullets()
	for b in all(bullets) do
		line(b.x,b.y,b.x-b.dx,b.y-b.dy)
	end
end

-->8
function line_intersect(a,b,c,d)
 s1_x = b[1] - a[1]
 s1_y = b[2] - a[2]
 s2_x = d[1] - c[1]
 s2_y = d[2] - c[2]
 
 sd = (s1_x*s2_y-s2_x*s1_y)
 if sd == 0 then
  return {res=false}
 end
 
 s = ((s1_x*(a[2]-c[2]))-(s1_y*(a[1]-c[1])))/sd
 t = ((s2_x*(a[2]-c[2]))-(s2_y*(a[1]-c[1])))/sd
 if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
  return {res=true,x=a[1]+t*s1_x,y=a[2]+t*s1_y}
 end
 
 return {res=false}
end

