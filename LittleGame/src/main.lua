--[[

记数字踩白块小游戏

2014/6/22
main.lua

]]
-- 引入card.lua文件
require( "src/card" )

--主方法
function Main()
  -- 创建一个场景
  local self = cc.Scene:create()

  -- 声明一个层
  local layer
  local allPoints -- 存储所有点
  local allCards = {} -- 存储所有卡片
  local currentNum -- 当前数字

  -- 生成可用点
  local function genPoints()
    allPoints = {}
    -- 6行*10列
    for i = 0, 9 do
      for j = 0, 5 do
        -- 插入点到allPoints数组当中
        table.insert( allPoints, 1, cc.p( i * 80, j * 80 ) )
      end
    end
   
  end

  -- 添加卡片
  local function addCards()

    -- 设置随机种子
    math.randomseed( os.time() )

    local c  -- 卡片
    local randNum -- 随机数
    local p -- 所在点

    -- 添加5张卡片
    for var = 1, 5 do
      c = card( var ) -- 生成一张卡片
      layer:addChild( c ) -- 添加到层当中
      -- 根据数组最大值生成随机数
      randNum = math.random( table.maxn(allPoints)  )
      p = table.remove( allPoints, randNum )
      c:setPosition( p )
      c:setAnchorPoint(  cc.p( 0, 0 ) )
      print("p.x:"..p.x..",p.y:"..p.y);
      
      -- 插入到卡片数组
      table.insert( allCards, 1, c )
    end

  end

  -- 开始游戏
  local function startGame()
    -- 初始值为1
    currentNum = 1
    -- 先生成可用点
    genPoints()
    -- 然后添加卡片
    addCards()
  end


  -- 显示所有卡片背景
  local function showAllCardsBg()
    for key, var in pairs(allCards) do
      var:showBg()
    end
  end

  -- 触摸事件，第一个参数为事件类型，第二个参数为x坐标，第二个为y坐标
  local function onTouch( type, x, y )
    -- 根据x,y生成一个点
    local p = cc.p(x,y)
    for key, var in pairs(allCards) do
      print(var:getPosition())
      -- 判断是否是点击范围
      local pX,pY = var:getPosition()
      if (p.x < (pX + 80)) and (p.y < (pY + 80) and (p.x > pX) and (p.y > pY)) then
      --if var:getBoundingBox():containsPoint(p) then
        if currentNum == var.num then
          -- 如果是点击的数字，则移除卡片
          table.remove(allCards, key)
          layer:removeChild(var, true)

          -- 点击了1之后，其他数字翻过背景
          if currentNum == 1 then
            showAllCardsBg()
          end

          -- 当所有卡片都被顺序点击了，提示成功
          if table.maxn( allCards ) <= 0 then
            print( "Success" )
            
          end

          -- 每次增加1
          currentNum = currentNum + 1
        end
      end
    end
  end

  -- 初始化方法
  local function init()

    -- 创建一个层
    layer = cc.Layer:create()
    -- 将层添加到场景
    self:addChild( layer )
    -- 设置可点击
    layer:setTouchEnabled( true )
    -- 注册监听事件
    layer:registerScriptTouchHandler( onTouch )
    -- 开始游戏
    startGame()
    -- self:addChild(layer)

    --    --测试代码
    --    local s = cc.Sprite:create("res/mn.jpg")
    --    s:setPosition(cc.p(0,0))
    --    s:setAnchorPoint( cc.p( 0, 0 ) )
    --    layer:addChild(s)
    --
    --    layer:setTouchEnabled(true)
    --    layer:registerScriptTouchHandler( function (type,x,y)
    --
    --        if s:getBoundingBox():containsPoint(cc.p(x,y)) then
    --          print("mn clicked")
    --        end
    --        print(type)
    --        return true
    --    end )
    --
    --    self:addChild(layer)
  end

  init()

  return self
end



--入口方法
local function _main()
  -- 获得导演类实例
  local dir = cc.Director:getInstance()
  -- 设置不显示帧
  dir:setDisplayStats(false)
  -- 运行场景
  dir:runWithScene(Main())

end

-- 调用入口方法
_main()