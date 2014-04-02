################################
# Settings
################################

settings =
  limitTime: 60 #sec
  countDown: 600 #millisecond
  levels:
    1: [
      '已證實智商與馬英九相同'
      '好了，下去領 500'
      '你是黨工？'
      '加油，好嗎？'
      '雨八 & 令刀'
    ]
    5: [
      '你的偷懶害立法院失守了'
      '白衫軍攻勢太強！'
      '請注意務必逐題審查！'
      '快重審！國會需要你！'
      '有沒有這麼強？沒有！'
    ]
    10: [
      '涂明義救援中！'
      '公聽會有辦等於沒辦！'
      '臉書被檢舉照片太醜<br>王偉忠：言語霸凌!'
      '秋意認為香蕉根本不重要'
      '戰神姚老師覺得你還可以再強'
    ]
    15: [
      '「你們不配當中國人」<BR>白狼語畢，哄堂大笑'
      '馬民調只有 9%，<br>但此分數已超過 9% 玩家'
      '先立法，再審查一次！'
      '~~~~~<a href="https://www.youtube.com/watch?v=yovi51Rqd3Q">歐ver買爹巴底</a>~~~~~'
    ]
    20: [
      '你競爭力超強，根本不需簽服貿'
      '辨識度堪稱糾察隊'
      '你的分辨力太高，中天都做不了假新聞...'
      '你的分辨力太高，TVBS 都做不了假新聞...'
    ]
    999: [
      '林飛帆與陳為廷在一起！'
      '不動如山，有如金平'
      '人民都像你一樣強就好了'
      '大家都像你這麼強，台灣早獨立了'
      '你證實了服貿應該要重審！'
      '你證明了 Z < B'
    ]

################################
# Elements
################################

$body        = $('body')

$btnPlay     = $('.play')
$btnYes      = $('.btn-yes')
$btnNo       = $('.btn-no')

$timestamp   = $('.timestamp')
$comment     = $('.comment')
$showPoint   = $('.showpoint')
$showContent = $('.show-content')
$gameover    = $('.gameover')

$.fn._bigtext = ->
  @.each ->
    $el = $(@)
    $el.bigtext $el.data()

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

  ################################
  # Actions
  ################################

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

  ################################
  # Reflections
  ################################

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

  ################################
  # Functions
  ################################

  getQuiz: ->
    $showContent.removeClass('in')
    numbers = if @point == 0 then 0 else if @point == 1 then 1 else if @point < 5 then ( @random(3) + 2 ) else if @point < 10 then ( @random(6) + 2 ) else (@random(8) + 5)
    quizStr = ''
    for i in [0..numbers] by 1
      quizStr += '反'
    @is_anti = if numbers % 2 == 0 then true else false
    $showContent.html("#{quizStr}服貿").parent()._bigtext()
    setTimeout( ->
      $showContent.addClass('in')
    , 300 )
  getComment: ->
    comment = "#{@point} 分點評："
    for key, value of settings.levels
      if @point < key
        comment += value[ Math.floor( Math.random() * value.length ) ]
        break
    @showComment comment
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

################################
# Initialize
################################
new game()
console && console.clear()
