if ('OpenFest-gauge-api' in localStorage) {
    if (localStorage['OpenFest-gauge-api'].startsWith('http://')) {
        localStorage['OpenFest-gauge-api'] = localStorage['OpenFest-gauge-api'].replace(/^http:\/\//, 'https://');
    }
}
