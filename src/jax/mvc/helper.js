/**
 * class Jax.Helper
 *
 * Jax Helpers are glorified mixins. They contain a set of methods which can then be
 * included into any Jax class.
 *
 * Defining a helper is easy, and looks a bit like this:
 *
 *     var HelloHelper = Jax.Helper.create({
 *       sayHi: function(name) { alert("Hello, "+name+"!"); }
 *     });
 *
 * Once defined, using helpers is particularly simple. In any Jax class, simply define
 * a +helpers+ function that returns an array of helpers:
 *
 *     var Liaison = Jax.Class.create({
 *       helpers: function() { return [HelloHelper]; }
 *     });
 *
 * Now the +Liaison+ class will include the +sayHi+ method which can be called just like
 * any other method:
 *
 *     var l = new Liaison();
 *     l.sayHi("World");
 *     //=> Hello, World!
 *
 **/
Jax.Helper = {
  instances: [],

  create: function(methods) {
    Jax.Helper.instances.push(methods);
    return methods;
  }
};
