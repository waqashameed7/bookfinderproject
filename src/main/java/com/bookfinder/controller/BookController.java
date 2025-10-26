package com.bookfinder.controller;

import com.bookfinder.model.Book;
import com.bookfinder.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class BookController {
    
    @Autowired
    private BookRepository bookRepository;
    
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("books", bookRepository.findAll());
        return "index";
    }
    
    @GetMapping("/search")
    public String searchBooks(@RequestParam String keyword, Model model) {
        List<Book> books = bookRepository.searchBooks(keyword);
        model.addAttribute("books", books);
        model.addAttribute("keyword", keyword);
        return "index";
    }
    
    @GetMapping("/add-book")
    public String showAddBookForm(Model model) {
        model.addAttribute("book", new Book());
        return "add-book";
    }
    
    @PostMapping("/add-book")
    public String addBook(@ModelAttribute Book book) {
        bookRepository.save(book);
        return "redirect:/";
    }
}