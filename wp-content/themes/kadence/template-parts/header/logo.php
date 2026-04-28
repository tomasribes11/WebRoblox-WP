<?php
/**
 * Template part for displaying the header branding/logo
 *
 * @package kadence
 */

namespace Kadence;

?>
<div class="site-header-item site-header-focus-item" data-section="title_tagline">
	<div class="custom-branding-wrapper">
		<a href="<?php echo esc_url( home_url( '/' ) ); ?>" class="custom-branding-link" rel="home">
			<div class="branding-content">
				<img src="<?php echo esc_url( get_template_directory_uri() ); ?>/assets/images/logo-custom.png" 
					 alt="Web Roblox Logo" 
					 class="custom-logo"
					 width="50" 
					 height="50">
				<span class="site-title-text">FINANZAS PERSONALES</span>
			</div>
		</a>
	</div>
</div><!-- data-section="title_tagline" -->
