 /**
     * Define a namespace for the application.
     */
    var wsApp = {};


    /**
     * @constructor
     * @extends {ol.interaction.Pointer}
     */
    wsApp.Drag = function() {

      ol.interaction.Pointer.call(this, {
        handleDownEvent: wsApp.Drag.prototype.handleDownEvent,
        handleDragEvent: wsApp.Drag.prototype.handleDragEvent,
        handleMoveEvent: wsApp.Drag.prototype.handleMoveEvent,
        handleUpEvent: wsApp.Drag.prototype.handleUpEvent
      });

      /**
       * @type {ol.Pixel}
       * @private
       */
      this.coordinate_ = null;

      /**
       * @type {string|undefined}
       * @private
       */
      this.cursor_ = 'pointer';

      /**
       * @type {ol.Feature}
       * @private
       */
      this.feature_ = null;

      /**
       * @type {string|undefined}
       * @private
       */
      this.previousCursor_ = undefined;

    };
    ol.inherits(wsApp.Drag, ol.interaction.Pointer);


    /**
     * @param {ol.MapBrowserEvent} evt Map browser event.
     * @return {boolean} `true` to start the drag sequence.
     */
    wsApp.Drag.prototype.handleDownEvent = function(evt) {
      var map = evt.map;

      var feature = map.forEachFeatureAtPixel(evt.pixel,
          function(feature) {
            return feature;
          });

      if (feature) {
        this.coordinate_ = evt.coordinate;
        this.feature_ = feature;
      }

      return !!feature;
    };


    /**
     * @param {ol.MapBrowserEvent} evt Map browser event.
     */
    wsApp.Drag.prototype.handleDragEvent = function(evt) {
      var deltaX = evt.coordinate[0] - this.coordinate_[0];
      var deltaY = evt.coordinate[1] - this.coordinate_[1];

      var geometry = /** @type {ol.geom.SimpleGeometry} */
          (this.feature_.getGeometry());
      geometry.translate(deltaX, deltaY);

      this.coordinate_ = evt.coordinate; 
      evt.map.getTargetElement().style.cursor = "move";
      
      var wgs84Val = ol.proj.transform(this.coordinate_,'EPSG:3857','EPSG:4326');
      $("#coordinatesInfo").html("经度:" + wgs84Val[0].toFixed(10) + "," + "纬度：" + wgs84Val[1].toFixed(10));
      nowCoordinates = wgs84Val;
    };


    /**
     * @param {ol.MapBrowserEvent} evt Event.
     */
    wsApp.Drag.prototype.handleMoveEvent = function(evt) {
      if (this.cursor_) {
        var map = evt.map;
        var feature = map.forEachFeatureAtPixel(evt.pixel,
            function(feature) {
              return feature;
            });
        var element = evt.map.getTargetElement();
        if (feature) {
          if (element.style.cursor != this.cursor_) {
            this.previousCursor_ = element.style.cursor;
            element.style.cursor = this.cursor_;
          }
        } else if (this.previousCursor_ !== undefined) {
          element.style.cursor = this.previousCursor_;
          this.previousCursor_ = undefined;
        }
      }
    };


    /**
     * @return {boolean} `false` to stop the drag sequence.
     */
    wsApp.Drag.prototype.handleUpEvent = function(evt) {
      evt.map.getTargetElement().style.cursor = "default";
      this.coordinate_ = null;
      this.feature_ = null;
      return false;
    };