$.fn._bigtext = ->
  @.each ->
    $el = $(@)
    $el.bigtext $el.data()

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
    @time       = 60
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
    , 500)
  bingo: ->
    @point++
    @getQuiz()
  end: ->
    @toggleBodyClass 'end'
    @getComment()
    @showPoint()
    clearTimeout @timer
    @reset()
    setTimeout( ->
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
    if @point < 1
      comment += '智商跟馬英九相同。'
    else if @point < 6
      comment += '你的偷懶害立法院失守了'
    else if @point < 7
      comment += '你的偷懶害立法院失守了'
    else if @point < 8
      comment += '白衫軍攻勢太強！<br>再玩一次！'
    else if @point < 9
      comment += '請注意務必逐題審查！'
    else if @point < 10
      comment += '快出門！<br>立法院需要你的支援！'
    else if @point < 11
      comment += 'Over My Dead Body'
    else if @point < 12
      comment += '涂明義救援中！'
    else if @point < 13
      comment += '公聽會有辦等於沒辦！'
    else if @point < 14
      comment += '臉書被檢舉照片太醜<br>王炳忠：言語霸凌!'
    else if @point < 15
      comment += '「你們不配當中國人」語畢，哄堂大笑'
    else if @point < 16
      comment += '馬總統民調只有九趴，<br>你們是不是也是多數在霸凌少數'
    else if @point < 17
      comment += '先立法後答題'
    else if @point < 18
      comment += '辨識度堪稱糾察隊'
    else if @point < 19
      comment += '辨識度堪稱糾察隊'
    else if @point < 20
      comment += '辨識度堪稱糾察隊'
    else if @point < 21
      comment += '林飛帆表示：陳為廷在我旁邊啦！'
    else if @point < 25
      comment += '你的分辨率太高，TVBS、中天都做不了假新聞...'
    else
      comment += '你證明了 Z < B'
    @showComment comment
  ## functions ###########################################
  showPoint: ->
    $showPoint.text(@point).parent()._bigtext()
  showComment: ( comment ) ->
    $comment.text comment
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
