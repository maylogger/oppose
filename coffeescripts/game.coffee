$.fn._bigtext = ->
  @.each ->
    $el = $(@)
    $el.bigtext $el.data()

settings =
  limitTime: 60
  countDown: 660
  levels:
    1: ['智商跟馬英九相同。']
    5: ['你的偷懶害立法院失守了', '白衫軍攻勢太強！<br>再玩一次！', '請注意務必逐題審查！', '快出門！<br>立法院需要你的支援！']
    10: ['Over My Dead Body', '涂明義救援中！', '公聽會有辦等於沒辦！', '臉書被檢舉照片太醜<br>王炳忠：言語霸凌!']
    15: ['「你們不配當中國人」語畢，哄堂大笑', '馬總統民調只有九趴，<br>你們是不是也是多數在霸凌少數', '先立法後答題', '辨識度堪稱糾察隊']
    20: ['林飛帆表示：陳為廷在我旁邊啦！', '你的分辨率太高，TVBS、中天都做不了假新聞...']
    999: ['你證明了 Z < B']

$body        = $('body')

$btnPlay     = $('.play')
$btnYes      = $('.btn-yes')
$btnNo       = $('.btn-no')

$timestamp   = $('.timestamp')
$comment     = $('.comment')
$showPoint   = $('.showpoint')
$showContent = $('.show-content')
$gameover    = $('.gameover')

class game
  constructor: ->
    $('.bigtext')._bigtext()
    @observe()
    @reset()
  reset: ->
    @time       = settings.limitTime
    @point      = 0
    @is_playing = false
    @showTime @time
  observe: ->
    $(document).on 'keydown', @keydown
    $btnPlay.on 'click', @play
    $btnYes.on 'click', @yes
    $btnNo.on 'click', @no
  keydown: (e) =>
    key = e.which
    switch key
      when 37
        @no()
      when 39
        @yes()
      when 13
        @play()
  play: =>
    return if @is_playing
    @is_playing = true
    @toggleBodyClass 'play'
    @getQuiz()
    @countdown()
    clearTimeout @gameroverTimer
    $gameover.addClass 'showGameOver'
  yes: =>
    return if not @is_playing
    if @is_anti then @end() else @bingo()
  no: =>
    return if not @is_playing
    if @is_anti then @bingo() else @end()
  countdown: ->
    return @end() if @time == 0
    return if not @is_playing
    @showTime @time
    @time--
    @timer = setTimeout( =>
      @countdown()
    , settings.countDown)
  bingo: ->
    @point++
    @getQuiz()
  end: ->
    @toggleBodyClass 'end'
    @getComment()
    @showPoint()
    clearTimeout @timer
    @reset()
    @gameroverTimer = setTimeout( ->
      $gameover.removeClass('showGameOver')
    , 1000)

  getQuiz: ->
    $showContent.removeClass('in')
    numbers = if @point < 9  then @random(4) else @random(13)
    quizStr = ''
    for i in [0..numbers] by 1
      quizStr += '反'
    @is_anti = if numbers % 2 == 0 then true else false
    $showContent.html("#{quizStr}服貿").parent()._bigtext()
    setTimeout( ->
      $showContent.addClass('in')
    , 300 )
  getComment: ->
    comment = '點評：'
    for key, value of settings.levels
      if @point < key
        comment = value[ Math.floor( Math.random() * value.length ) ]
        break
    @showComment comment
  ## functions ###########################################
  showPoint: ->
    $showPoint.text(@point).parent()._bigtext()
  showComment: ( comment ) ->
    $comment.html comment
  showTime: ( time ) ->
    $timestamp.text time
  random: (max) ->
    Math.ceil( Math.random() * max )
  toggleBodyClass: ( status ) ->
    switch status
      when 'play'
        $body.removeClass('status-intro status-end').addClass('status-playing')
      when 'end'
        $body.removeClass('status-playing').addClass('status-end')
new game()

# console && console.clear()
