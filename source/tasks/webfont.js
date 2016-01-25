// Creates font icon from all the SVG files in the source folder's icon directory. The generated font is placed into the
// test folder's font directory.

// USAGE:
// If you have a svg file called calendar.svg, then the icon can be used in the HTMl as <i class="icon-calendar"></i>

module.exports = {
    icons: {
        src: '<%= config.path.source %>/icon/*.svg',
        dest: '<%= config.path.test %>/<%= config.asset.font %>/icon-font',
        options: {
            engine           : 'node',
            classPrefix      : 'icon-',
            stylesheet       : 'scss',
            types            : 'eot, woff2, woff, ttf, svg',
            order            : 'eot, woff2, woff, ttf, svg',
            syntax           : 'bootstrap',
            destCss          : '<%= config.path.source %>/sass/core/',
            relativeFontPath : '../font/icon-font/',
            fontHeight       : 1024,
            htmlDemo         : false,
            template         : '<%= config.path.source %>/config/iconsTemplate.css'
        }
    }
};
