package com.example.validation;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;
import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class PlayerTest {

    private static ValidatorFactory validatorFactory;
    private static Validator validator;

    @BeforeClass
    public static void createValidator() {
        validatorFactory = Validation.buildDefaultValidatorFactory();
        validator = validatorFactory.getValidator();
    }

    @AfterClass
    public static void close() {
        validatorFactory.close();
    }

    @Test
    public void shouldHaveNoViolations() {
        //given:
        Player player = new Player("ABC", 44);

        //when:
        Set<ConstraintViolation<Player>> violations
                = validator.validate(player);

        //then:
        assertTrue(violations.isEmpty());
    }

    @Test
    public void shouldDetectInvalidName() {
        //given too short name:
        Player player = new Player("a", 44);

        //when:
        Set<ConstraintViolation<Player>> violations
                = validator.validate(player);

        //then:
        assertEquals(violations.size(), 1);

        ConstraintViolation<Player> violation
                = violations.iterator().next();
        assertEquals("size must be between 3 and 3",
                violation.getMessage());
        assertEquals("name", violation.getPropertyPath().toString());
        assertEquals("a", violation.getInvalidValue());
    }

    @Test
    public void shouldDetectInvalidScore() {
        //given too short name:
        Player player = new Player("abc", 144);

        //when:
        Set<ConstraintViolation<Player>> violations
                = validator.validate(player);

        //then:
        assertEquals(violations.size(), 1);

        ConstraintViolation<Player> violation
                = violations.iterator().next();
        assertEquals("must be less than or equal to 100",
                violation.getMessage());
        assertEquals("score", violation.getPropertyPath().toString());
        assertEquals(144, violation.getInvalidValue());
    }
}
