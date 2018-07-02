({
	helperMethod : function() {
		
	},
    
    helperAfterRender : function(component){
        var locations = window.location, xlinkhref=component.get('v.xlinkHref'), pathFix='',
            auraHtmlSpan = component.find("svg_content"), classname = component.get("v.class"),
            svgns = "http://www.w3.org/2000/svg",
            xlinkns = "http://www.w3.org/1999/xlink",
            useId = component.get('v.elementId'),
            svg = document.createElementNS(svgns, "svg");
        
        
        pathFix = locations['pathname'].split('/');
    //    xlinkhref = (locations['origin']+'/'+pathFix[1]+xlinkhref);
   //     xlinkhref = (locations['origin']+'/'+pathFix[1]+xlinkhref);
   //     console.log( xlinkhref );
        svg.setAttribute('class', classname);
        svg.setAttribute('aria-hidden', true);
   //     svg.innerHTML = '<use id="'+useId+'" xlink:href="'+xlinkhref+'"></use>';
		
        var use=document.createElementNS(svgns, "use");
        use.setAttributeNS(xlinkns, "href", xlinkhref);
        svg.appendChild(use);
        
        auraHtmlSpan.getElement().appendChild(svg);
        
        
        
        /*
        	html = document.getElementsByTagName("html")[0];
        
        html.setAttribute("xmlns", "http://www.w3.org/2000/svg");
        html.setAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink");
        */
        
    }
})