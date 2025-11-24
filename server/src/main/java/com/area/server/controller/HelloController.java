package com.area.server.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String home() {
        return "Welcome to AREA Backend! The server is running successfully.";
    }

    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}

