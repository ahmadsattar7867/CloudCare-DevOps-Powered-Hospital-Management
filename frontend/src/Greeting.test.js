// src/Greeting.test.js
import React from 'react';
import { render, screen } from '@testing-library/react';
import Greeting from './Greeting';
import '@testing-library/jest-dom'; // Ensure this is imported

describe('Greeting Component', () => {
    test('renders the correct greeting message', () => {
        render(<Greeting name="Ahmad" />);
        const greetingElement = screen.getByText(/hello, ahmad!/i);
        expect(greetingElement).toBeInTheDocument(); // Now this should work
    });
});
