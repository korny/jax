describe("Jax.MatrixStack", function() {
  var stack;
  
  beforeEach(function() { stack = new Jax.MatrixStack(); });
  
  it('should return a model matrix', function() { expect(stack.getModelMatrix()).not.toBeUndefined(); });
  it('should return a view matrix', function() { expect(stack.getViewMatrix()).not.toBeUndefined(); });
  it('should return a proj matrix', function() { expect(stack.getProjectionMatrix()).not.toBeUndefined(); });
      
  describe("with a pushed matrix", function() {
    beforeEach(function() { stack.push(); });
    
    it('should return a model matrix', function() { expect(stack.getModelMatrix()).not.toBeUndefined(); });
    it('should return a view matrix', function() { expect(stack.getViewMatrix()).not.toBeUndefined(); });
    it('should return a proj matrix', function() { expect(stack.getProjectionMatrix()).not.toBeUndefined(); });
      
    describe("translate", function() {
      beforeEach(function() { stack.loadViewMatrix(mat4.translate(Jax.IDENTITY_MATRIX, [1,1,1], mat4.create())); });
      
      it("should not be an identity matrix", function() { expect(stack.getViewMatrix()).not.toEqualMatrix(Jax.IDENTITY_MATRIX); });
      
      it("should produce coords relative to eye", function() {
        var vec = mat4.multiplyVec3(stack.getInverseViewMatrix(), [0,0,0]);
        expect(vec).toEqualVector([-1,-1,-1]);
      });
    });
  });
});
