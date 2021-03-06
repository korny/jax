describe("Jax.Canvas", function() {
  var context, canvas;
  
  describe("with no routes", function() {
    beforeEach(function() { 
      Jax.routes.clear();
      var canvas = document.createElement('canvas');
      canvas.setAttribute("id", "c");
      canvas.setAttribute("width", "100");
      canvas.setAttribute("height", "100");
      canvas.style.display = "none";
      document.body.appendChild(canvas);
      context = new Jax.Context(canvas);
    });
    afterEach(function() { context.dispose(); document.body.removeChild(canvas); });
  
    it("should keep a handle to canvas", function() {
      expect(context.canvas.id).toEqual("c");
    });
  
    it("should not be rendering, because there's no root controller", function() {
      expect(context.isRendering()).toBeFalsy();
    });
    
    describe("after disposal", function() {
      beforeEach(function() { context.dispose(); });
      
      it("should unregister all event handlers", function() {
        expect(context.canvas.getEventListeners('click')).toBeEmpty();
        expect(context.canvas.getEventListeners('mousedown')).toBeEmpty();
        expect(context.canvas.getEventListeners('mousemove')).toBeEmpty();
        expect(context.canvas.getEventListeners('mouseout')).toBeEmpty();
        expect(context.canvas.getEventListeners('mouseover')).toBeEmpty();
        expect(context.canvas.getEventListeners('mouseup')).toBeEmpty();
        expect(context.canvas.getEventListeners('keydown')).toBeEmpty();
        expect(context.canvas.getEventListeners('keypress')).toBeEmpty();
        expect(context.canvas.getEventListeners('keyup')).toBeEmpty();
        expect(context.canvas.getEventListeners('onclick')).toBeEmpty();
        expect(context.canvas.getEventListeners('onmousedown')).toBeEmpty();
        expect(context.canvas.getEventListeners('onmousemove')).toBeEmpty();
        expect(context.canvas.getEventListeners('onmouseout')).toBeEmpty();
        expect(context.canvas.getEventListeners('onmouseover')).toBeEmpty();
        expect(context.canvas.getEventListeners('onmouseup')).toBeEmpty();
        expect(context.canvas.getEventListeners('onkeydown')).toBeEmpty();
        expect(context.canvas.getEventListeners('onkeypress')).toBeEmpty();
        expect(context.canvas.getEventListeners('onkeyup')).toBeEmpty();
      });
    });
  });
  
  describe("when redirecting", function() {
    beforeEach(function() {
      jasmine.Clock.useMock();
      
      Jax.routes.clear();
      
      Jax.views.push('one/index', function() { });
      Jax.views.push('two/index', function() { });

      var one = Jax.Controller.create("one", {index:function() {}});
      var two = Jax.Controller.create("two", {
        index:function() { this.world.addObject(new Jax.Model()); },
        update: function(tc) {  }
      });
      
      Jax.routes.map("/", one);
      Jax.routes.map("two", two);
      
      context = new Jax.Context(SPEC_CONTEXT.canvas);
    });
    
    afterEach(function() { context.dispose(); });
    
    it("should dispose the world", function() {
      spyOn(context.world, 'dispose').andCallThrough();
      context.redirectTo("two");
      expect(context.world.dispose).toHaveBeenCalled();
    });
    
    it("to a bad route should stop execution of current controller", function() {
      context.redirectTo("two");
      var two_instance = context.current_controller;
      
      jasmine.Clock.tick(Jax.update_speed+1);
      expect(function() { context.redirectTo("invalid"); }).toThrow("Route not recognized: 'invalid'");
      expect(context.world.objects.length).toEqual(0);
      
      spyOn(two_instance, "update"); // notice we can't do this earlier because it *does* get called above
      jasmine.Clock.tick(Jax.update_speed+1);
      expect(two_instance.update).not.toHaveBeenCalled();
    });
  });
  
  describe("with routes", function() {
    var controller;
    var action_called = 0, view_called = 0;
    
    beforeEach(function() {
      Jax.routes.clear();
      Jax.routes.root(Jax.Controller.create("welcome", {index: function() { action_called++; }}), "index");
      Jax.views.push("welcome/index", function() {
        this.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        view_called++;
      });
      context = new Jax.Context(SPEC_CONTEXT.canvas);
    });
    afterEach(function() { context.dispose(); });
  
    it("should be rendering, because there's a controller", function() {
      expect(context.isRendering()).toBeTruthy();
    });
  });
});
