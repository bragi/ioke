package ioke.lang;

import ioke.lang.exceptions.ControlFlow;

public class RunnableWithErrorCondition implements RunnableWithControlFlow {
	IokeObject condition;
	
	public RunnableWithErrorCondition(IokeObject condition) {
		this.condition = condition;
	}

	public void run() throws ControlFlow {
		condition.runtime.errorCondition(condition);
	}

}
