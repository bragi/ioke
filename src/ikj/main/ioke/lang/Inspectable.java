/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import ioke.lang.exceptions.ControlFlow;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public interface Inspectable {
    public String inspect(Object self) throws ControlFlow;
    public String notice(Object self) throws ControlFlow;
}// Inspectable
