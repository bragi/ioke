include_class('ioke.lang.Runtime') { 'IokeRuntime' } unless defined?(IokeRuntime)

describe "true" do 
  describe "'false?'" do 
    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true false?").should == ioke.false
      ioke.evaluate_string("x = true. x false?").should == ioke.false
    end
  end

  describe "'true?'" do 
    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true true?").should == ioke.true
      ioke.evaluate_string("x = true. x true?").should == ioke.true
    end
  end

  describe "'not'" do 
    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true not").should == ioke.false
      ioke.evaluate_string("x = true. x not").should == ioke.false
    end
  end

  describe "'and'" do 
    it "should evaluate it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. true and(x=42). x").data.as_java_integer.should == 42
    end

    it "should complain if no argument is given" do 
      ioke = IokeRuntime.get_runtime
      proc do 
        ioke.evaluate_string("true and()")
      end.should raise_error
    end

    it "should return the result of the argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true and(42)").data.as_java_integer.should == 42
    end

    it "should be available in infix" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true and 43").data.as_java_integer.should == 43
    end
  end

  describe "'or'" do 
    it "should not evaluate it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. true or(x=42). x").data.as_java_integer.should == 41
    end

    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true or(42)").should == ioke.true
    end

    it "should be available in infix" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true or 43").should == ioke.true
    end
  end

  describe "'ifTrue'" do 
    it "should execute it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. true ifTrue(x=42). x").data.as_java_integer.should == 42
    end

    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true ifTrue(x=42)").should == ioke.true
    end
  end

  describe "'ifFalse'" do 
    it "should not execute it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. true ifFalse(x=42). x").data.as_java_integer.should == 41
    end

    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("true ifFalse(x=42)").should == ioke.true
    end
  end
end

describe "false" do 
  describe "'false?'" do 
    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false false?").should == ioke.true
      ioke.evaluate_string("x = false. x false?").should == ioke.true
    end
  end

  describe "'true?'" do 
    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false true?").should == ioke.false
      ioke.evaluate_string("x = false. x true?").should == ioke.false
    end
  end

  describe "'not'" do 
    it "should return true" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false not").should == ioke.true
      ioke.evaluate_string("x = false. x not").should == ioke.true
    end
  end

  describe "'and'" do 
    it "should not evaluate it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. false and(x=42). x").data.as_java_integer.should == 41
    end

    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false and(42)").should == ioke.false
    end

    it "should be available in infix" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false and 43").should == ioke.false
    end
  end

  describe "'or'" do 
    it "should evaluate it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. false or(x=42). x").data.as_java_integer.should == 42
    end

    it "should complain if no argument is given" do 
      ioke = IokeRuntime.get_runtime
      proc do 
        ioke.evaluate_string("false or()")
      end.should raise_error
    end

    it "should return the result of the argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false or(42)").data.as_java_integer.should == 42
    end

    it "should be available in infix" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false or 43").data.as_java_integer.should == 43
    end
  end

  describe "'ifTrue'" do 
    it "should not execute it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. false ifTrue(x=42). x").data.as_java_integer.should == 41
    end

    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false ifTrue(x=42)").should == ioke.false
    end
  end

  describe "'ifFalse'" do 
    it "should execute it's argument" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("x=41. false ifFalse(x=42). x").data.as_java_integer.should == 42
    end

    it "should return false" do 
      ioke = IokeRuntime.get_runtime
      ioke.evaluate_string("false ifFalse(x=42)").should == ioke.false
    end
  end
end