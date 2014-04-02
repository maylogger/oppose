(function() {
  var $body, $btnNo, $btnPlay, $btnYes, $comment, $gameover, $showContent, $showPoint, $timestamp, game, settings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $.fn._bigtext = function() {
    return this.each(function() {
      var $el;

      $el = $(this);
      return $el.bigtext($el.data());
    });
  };

  settings = {
    limitTime: 60,
    countDown: 660,
    levels: {
      1: ['已證實智商與馬英九相同'],
      5: ['你的偷懶害立法院失守了', '白衫軍攻勢太強！<br>再玩一次！', '請注意務必逐題審查！', '快出門！<br>立法院需要你的支援！'],
      10: ['Over My Dead Body', '涂明義救援中！', '公聽會有辦等於沒辦！', '臉書被檢舉照片太醜<br>王炳忠：言語霸凌!'],
      15: ['「你們不配當中國人」語畢，哄堂大笑', '馬總統民調只有九趴，<br>你們是不是也是多數在霸凌少數', '先立法後答題', '辨識度堪稱糾察隊'],
      20: ['林飛帆表示：陳為廷在我旁邊啦！', '你的分辨率太高，TVBS、中天都做不了假新聞...'],
      999: ['你證明了 Z < B']
    }
  };

  $body = $('body');

  $btnPlay = $('.play');

  $btnYes = $('.btn-yes');

  $btnNo = $('.btn-no');

  $timestamp = $('.timestamp');

  $comment = $('.comment');

  $showPoint = $('.showpoint');

  $showContent = $('.show-content');

  $gameover = $('.gameover');

  game = (function() {
    function game() {
      this.no = __bind(this.no, this);
      this.yes = __bind(this.yes, this);
      this.play = __bind(this.play, this);
      this.keydown = __bind(this.keydown, this);      $('.bigtext')._bigtext();
      this.observe();
      this.reset();
    }

    game.prototype.reset = function() {
      this.time = settings.limitTime;
      this.point = 0;
      this.is_playing = false;
      return this.showTime(this.time);
    };

    game.prototype.observe = function() {
      $(document).on('keydown', this.keydown);
      $btnPlay.on('click', this.play);
      $btnYes.on('click', this.yes);
      return $btnNo.on('click', this.no);
    };

    game.prototype.keydown = function(e) {
      var key;

      key = e.which;
      switch (key) {
        case 37:
          return this.no();
        case 39:
          return this.yes();
        case 13:
          return this.play();
      }
    };

    game.prototype.play = function() {
      if (this.is_playing) {
        return;
      }
      this.is_playing = true;
      this.toggleBodyClass('play');
      this.getQuiz();
      this.countdown();
      clearTimeout(this.gameroverTimer);
      return $gameover.addClass('showGameOver');
    };

    game.prototype.yes = function() {
      if (!this.is_playing) {
        return;
      }
      if (this.is_anti) {
        return this.end();
      } else {
        return this.bingo();
      }
    };

    game.prototype.no = function() {
      if (!this.is_playing) {
        return;
      }
      if (this.is_anti) {
        return this.bingo();
      } else {
        return this.end();
      }
    };

    game.prototype.countdown = function() {
      var _this = this;

      if (this.time === 0) {
        return this.end();
      }
      if (!this.is_playing) {
        return;
      }
      this.showTime(this.time);
      this.time--;
      return this.timer = setTimeout(function() {
        return _this.countdown();
      }, settings.countDown);
    };

    game.prototype.bingo = function() {
      this.point++;
      return this.getQuiz();
    };

    game.prototype.end = function() {
      this.toggleBodyClass('end');
      this.getComment();
      this.showPoint();
      clearTimeout(this.timer);
      this.reset();
      return this.gameroverTimer = setTimeout(function() {
        return $gameover.removeClass('showGameOver');
      }, 1000);
    };

    game.prototype.getQuiz = function() {
      var i, numbers, quizStr, _i;

      $showContent.removeClass('in');
      numbers = this.point < 9 ? this.random(4) : this.random(13);
      quizStr = '';
      for (i = _i = 0; _i <= numbers; i = _i += 1) {
        quizStr += '反';
      }
      this.is_anti = numbers % 2 === 0 ? true : false;
      $showContent.html("" + quizStr + "服貿").parent()._bigtext();
      return setTimeout(function() {
        return $showContent.addClass('in');
      }, 300);
    };

    game.prototype.getComment = function() {
      var comment, key, value, _ref;

      comment = '點評：';
      _ref = settings.levels;
      for (key in _ref) {
        value = _ref[key];
        if (this.point < key) {
          comment = value[Math.floor(Math.random() * value.length)];
          break;
        }
      }
      return this.showComment(comment);
    };

    game.prototype.showPoint = function() {
      return $showPoint.text(this.point).parent()._bigtext();
    };

    game.prototype.showComment = function(comment) {
      return $comment.html(comment);
    };

    game.prototype.showTime = function(time) {
      return $timestamp.text(time);
    };

    game.prototype.random = function(max) {
      return Math.ceil(Math.random() * max);
    };

    game.prototype.toggleBodyClass = function(status) {
      switch (status) {
        case 'play':
          return $body.removeClass('status-intro status-end').addClass('status-playing');
        case 'end':
          return $body.removeClass('status-playing').addClass('status-end');
      }
    };

    return game;

  })();

  new game();

}).call(this);
